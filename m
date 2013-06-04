Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3FDXj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:39:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51484 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750791Ab3FDXjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:39:25 -0400
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] jfs: neatening
Date: Tue,  4 Jun 2013 16:39:14 -0700
Message-Id: <cover.1370388945.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second patch is speculative and maybe not necessary.

Is a 3KB reduction in object size when embedded and !CONFIG_PRINTK worth it?

Joe Perches (2):
  jfs: Update jfs_error
  jfs: Reduce object size when CONFIG_PRINTK=n

 fs/jfs/jfs_dmap.c       | 70 +++++++++++++++++++------------------------------
 fs/jfs/jfs_dtree.c      | 37 +++++++++++++-------------
 fs/jfs/jfs_extent.c     |  2 +-
 fs/jfs/jfs_imap.c       | 69 ++++++++++++++++++++----------------------------
 fs/jfs/jfs_metapage.c   |  5 ++--
 fs/jfs/jfs_superblock.h | 17 +++++++++++-
 fs/jfs/jfs_txnmgr.c     |  2 +-
 fs/jfs/jfs_xtree.c      | 62 +++++++++++++++++++++----------------------
 fs/jfs/namei.c          |  2 +-
 fs/jfs/resize.c         |  2 +-
 fs/jfs/super.c          | 24 ++++++++++-------
 fs/jfs/xattr.c          |  4 +--
 12 files changed, 142 insertions(+), 154 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

