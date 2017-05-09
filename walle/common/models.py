#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: wushuiyong
# @Created Time : 日  1/ 1 23:43:12 2017
# @Description:

import json
from sqlalchemy import Column, String, Integer, create_engine, Text, DateTime
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from flask import jsonify

from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.login import current_user
from werkzeug.security import check_password_hash,generate_password_hash
from flask.ext.login import UserMixin
from pickle import dump

# from flask.ext.cache import Cache
from datetime import datetime
import time

db = SQLAlchemy()


# 上线单
class Task(db.Model):
    # 表的名字:
    __tablename__ = 'task'

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(Integer)
    project_id = db.Column(Integer)
    action = db.Column(Integer)
    status = db.Column(Integer)
    title = db.Column(String(100))
    link_id = db.Column(String(100))
    ex_link_id = db.Column(String(100))
    servers = db.Column(Text)
    commit_id = db.Column(String(40))
    branch = db.Column(String(100))
    file_transmission_mode = db.Column(Integer)
    file_list = db.Column(Text)
    enable_rollback = db.Column(Integer)
    created_at = db.Column(DateTime)
    updated_at = db.Column(DateTime)

    taskMdl = None

    def __init__(self, task_id=None):
        if task_id:
            self.id = task_id
            self.taskMdl = Task.query.filter_by(id=self.id).one().to_json()

    def table_name(self):
        return self.__tablename__

    def __repr__(self):
        return '<User %r>' % (self.title)

    def to_json(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'project_id': self.project_id,
            'action': self.action,
            'status': self.status,
            'title': self.title,
            'link_id': self.link_id,
            'ex_link_id': self.ex_link_id,
            'servers': self.servers,
            'commit_id': self.commit_id,
            'branch': self.branch,
            'file_transmission_mode': self.file_transmission_mode,
            'file_list': self.file_list,
            'enable_rollback': self.enable_rollback,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }

    def list(self, page=0, size=10):
        data = Task.query.order_by('id').offset(int(size) * int(page)).limit(size).all()
        return [p.to_json() for p in data]

    def one(self):
        project_info = Project.query.filter_by(id=self.taskMdl.get('project_id')).one().to_json()
        return dict(project_info, **self.taskMdl)


# 上线记录表
class TaskRecord(db.Model):
    # 表的名字:
    __tablename__ = 'task_record'

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    stage = db.Column(String(20))
    sequence = db.Column(Integer)
    user_id = db.Column(Integer)
    task_id = db.Column(Integer)
    status = db.Column(Integer)
    command = db.Column(String(200))
    success = db.Column(String(2000))
    error = db.Column(String(2000))

    def save_record(self, stage, sequence, user_id, task_id, status, command, success, error):
        record = TaskRecord(stage=stage, sequence=sequence, user_id=user_id,
                            task_id=task_id, status=status, command=command,
                            success=success, error=error)
        db.session.add(record)
        return db.session.commit()


# 环境级别
class enviroment(db.Model):
    # 表的名字:
    __tablename__ = 'enviroment'

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    name = db.Column(String(20))
    status = db.Column(Integer)


# 项目配置表
class Project(db.Model):
    # 表的名字:
    __tablename__ = 'project'

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(Integer)
    name = db.Column(String(100))
    environment_id = db.Column(Integer)
    status = db.Column(Integer)
    version = db.Column(String(40))
    excludes = db.Column(Text)
    target_user = db.Column(String(50))
    target_root = db.Column(String(200))
    target_library = db.Column(String(200))
    servers = db.Column(Text)
    prev_deploy = db.Column(Text)
    post_deploy = db.Column(Text)
    prev_release = db.Column(Text)
    post_release = db.Column(Text)
    post_release_delay = db.Column(Integer)
    keep_version_num = db.Column(Integer)
    repo_url = db.Column(String(200))
    repo_username = db.Column(String(50))
    repo_password = db.Column(String(50))
    repo_mode = db.Column(String(50))
    repo_type = db.Column(String(10))

    def to_json(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'name': self.name,
            'environment_id': self.environment_id,
            'status': self.status,
            'version': self.version,
            'excludes': self.excludes,
            'target_user': self.target_user,
            'target_root': self.target_root,
            'target_library': self.target_library,
            'servers': self.servers,
            'prev_deploy': self.prev_deploy,
            'post_deploy': self.post_deploy,
            'prev_release': self.prev_release,
            'post_release': self.post_release,
            'post_release_delay': self.post_release_delay,
            'keep_version_num': self.keep_version_num,
            'repo_url': self.repo_url,
            'repo_username': self.repo_username,
            'repo_password': self.repo_password,
            'repo_mode': self.repo_mode,
            'repo_type': self.repo_type,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }

# 项目配置表
class User(db.Model, UserMixin):
    # 表的名字:
    __tablename__ = 'user'

    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    password_hash = 'sadfsfkk'
    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    username = db.Column(String(50))
    is_email_verified = db.Column(Integer, default=0)
    email = db.Column(String(50), unique=True, nullable=False)
    password = db.Column(String(50), nullable=False)
    # password_hash = db.Column(String(50), nullable=False)
    avatar = db.Column(String(100))
    role_id = db.Column(Integer, default=0)
    status = db.Column(Integer, default=0)
    created_at = db.Column(DateTime, default=current_time)
    updated_at = db.Column(DateTime, default=current_time, onupdate=current_time)
    #
    # def __init__(self, email=None, password=None):
    #     from walle.common.tokens import TokenManager
    #     tokenManage = TokenManager()
    #     if email and password:
    #         self.email = email
    #         self.username = email
    #         self.password = tokenManage.generate_token(password)
    #         self.role_id = 0
    #         self.is_email_verified = 0
    #         self.status = 0
    #
    # @property
    # def password(self):
    #     """
    #     明文密码（只读）
    #     :return:
    #     """
    #     raise AttributeError(u'文明密码不可读')
    #
    #
    # @password_login.setter
    # def password_login(self, value):
    #     """
    #     写入密码，同时计算hash值，保存到模型中
    #     :return:
    #     """
    #     self.password = generate_password_hash(value)

    def verify_password(self, password):
        """
        检查密码是否正确
        :param password:
        :return:
        """
        if self.password is None:
            return False
        return check_password_hash(self.password, password)


    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        try:
            return unicode(self.id)  # python 2
        except NameError:
            return str(self.id)  # python 3

    def to_json(self):
        return {
            'id': self.id,
            'username': self.username,
            'is_email_verified': self.is_email_verified,
            'email': self.email,
            'avatar': self.avatar,
            'role_id': self.role_id,
            'status': self.status,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }

# 项目配置表
class Role(db.Model):
    # 表的名字:
    __tablename__ = 'role'

    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    name = db.Column(String(30))
    permission_ids = db.Column(Text, default='')
    created_at = db.Column(DateTime, default=current_time)
    updated_at = db.Column(DateTime, default=current_time, onupdate=current_time)


    def list(self, page=0, size=10, kw=''):
        """
        获取分页列表
        :param page:
        :param size:
        :return:
        """
        query = Role.query
        if kw:
            query = query.filter(Role.name.like('%' + kw + '%'))
        data = query.order_by('id desc').offset(int(size) * int(page)).limit(size).all()
        return [p.to_json() for p in data]

    def item(self, role_id):
        """
        获取单条记录
        :param role_id:
        :return:
        """
        data = Role.query.filter_by(id=role_id).first()
        return data.to_json() if data else []

    def remove(self, role_id):
        """

        :param role_id:
        :return:
        """
        return Role.query.filter_by(id=role_id).delete()


    def to_json(self):
        return {
            'id': self.id,
            'name': self.name,
            'permission_ids': self.permission_ids,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }

# 项目配置表
class Tag(db.Model):
    # 表的名字:
    __tablename__ = 'tag'

    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    name = db.Column(String(30))
    label = db.Column(String(30))
    created_at = db.Column(DateTime, default=current_time)
    updated_at = db.Column(DateTime, default=current_time, onupdate=current_time)

    def to_json(self):
        return {
            'id': self.id,
            'name': self.name,
            'label': self.label,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }


# 项目配置表
class Group(db.Model):
    # 表的名字:
    __tablename__ = 'user_group'

    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # 表的结构:
    id = db.Column(Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(Integer, default=0)
    group_id = db.Column(Integer, default=0)
    created_at = db.Column(DateTime, default=current_time)
    updated_at = db.Column(DateTime, default=current_time, onupdate=current_time)



    def list(self, page=0, size=10, kw=''):
        """
        获取分页列表
        :param page:
        :param size:
        :return:
        """
        query = Tag.query
        if kw:
            query = query.filter(Tag.name.like('%' + kw + '%'))
        data = query.order_by('id desc').offset(int(size) * int(page)).limit(size).all()
        return [p.to_json() for p in data]


    def add(self, name):
        tag = Tag(name=name, label='user_group')
        db.session.add(tag)
        return db.session.commit()

    def update(self, group_id, group_name):
        data = Tag.query.filter_by(label='user_group', id=group_id).first()
        data.name = group_name
        return db.session.commit()


    def item(self, group_id):
        """
        获取单条记录
        :param role_id:
        :return:
        """

        data = Group.query.join(User, User.id == Group.user_id)\
            .add_columns(User.id, User.username, Group.id)\
            .filter(Group.group_id == group_id).first()
        f = open('aa.txt', 'w')
        dump(data, f)
        # print(data)
        return []
        return data.to_json() if data else []

    def remove(self, role_id):
        """

        :param role_id:
        :return:
        """
        return Group.query.filter_by(id=role_id).delete()


    def to_json(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
        }

