Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbaKBF7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 01:59:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60010 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaKBF66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 01:58:58 -0400
Date: Sun, 2 Nov 2014 05:58:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20141102055856.GU7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A bunch of assorted fixes, most of them - followups to overlayfs
merge.  Please, pull from the usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      overlayfs: barriers for opening upper-layer directory
      isofs_cmp(): we'll never see a dentry for . or ..
      isofs: don't bother with ->d_op for normal case

Daniel Thompson (1):
      staging: android: logger: Fix log corruption regression

David Jeffery (1):
      Return short read or 0 at end of a raw device, not EIO

Miklos Szeredi (3):
      ovl: fix check for cursor
      overlayfs: fix lockdep misannotation
      ovl: initialize ->is_cursor

Paul E. McKenney (1):
      rcu: Provide counterpart to rcu_dereference() for non-RCU situations

Diffstat:
 drivers/char/raw.c               |    2 +-
 drivers/staging/android/logger.c |   13 ++++++++-----
 fs/block_dev.c                   |    3 ++-
 fs/isofs/inode.c                 |   24 ++----------------------
 fs/isofs/namei.c                 |   22 ++++------------------
 fs/namei.c                       |    2 +-
 fs/overlayfs/readdir.c           |   17 ++++++++++-------
 include/linux/fs.h               |   10 +++++++---
 include/linux/rcupdate.h         |   15 +++++++++++++++
 9 files changed, 50 insertions(+), 58 deletions(-)
