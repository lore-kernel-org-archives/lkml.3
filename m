Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab3DHQhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:37:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32954 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754481Ab3DHQht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:37:49 -0400
From: Joe Perches <joe@perches.com>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] hfs/hfsplus: Modernize logging styles
Date: Mon,  8 Apr 2013 09:37:38 -0700
Message-Id: <cover.1365438493.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <1365401315.2673.11.camel@slavad-ubuntu>
References: <1365401315.2673.11.camel@slavad-ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  hfs/hfsplus: Convert dprint to hfs_dbg
  hfs/hfsplus: Convert printks to pr_<level>

 fs/hfs/bfind.c          | 10 +++++----
 fs/hfs/bitmap.c         |  4 ++--
 fs/hfs/bnode.c          | 39 ++++++++++++++++++----------------
 fs/hfs/brec.c           | 19 +++++++++--------
 fs/hfs/btree.c          | 31 ++++++++++++++-------------
 fs/hfs/catalog.c        | 12 ++++++-----
 fs/hfs/dir.c            | 12 +++++------
 fs/hfs/extent.c         | 20 ++++++++++--------
 fs/hfs/hfs_fs.h         | 20 ++++++++++++++++--
 fs/hfs/inode.c          |  4 ++--
 fs/hfs/mdb.c            | 23 ++++++++++----------
 fs/hfs/super.c          | 43 +++++++++++++++++++------------------
 fs/hfsplus/attributes.c | 26 +++++++++++------------
 fs/hfsplus/bfind.c      |  6 +++---
 fs/hfsplus/bitmap.c     | 12 +++++------
 fs/hfsplus/bnode.c      | 36 +++++++++++++++----------------
 fs/hfsplus/brec.c       | 14 ++++++-------
 fs/hfsplus/btree.c      | 29 +++++++++++++------------
 fs/hfsplus/catalog.c    | 11 +++++-----
 fs/hfsplus/dir.c        | 14 ++++++-------
 fs/hfsplus/extents.c    | 32 ++++++++++++++--------------
 fs/hfsplus/hfsplus_fs.h | 20 +++++++++++++++---
 fs/hfsplus/inode.c      |  4 ++--
 fs/hfsplus/options.c    | 22 +++++++++----------
 fs/hfsplus/super.c      | 56 +++++++++++++++++++------------------------------
 fs/hfsplus/wrapper.c    |  8 +++----
 fs/hfsplus/xattr.c      | 41 ++++++++++++++++++------------------
 27 files changed, 296 insertions(+), 272 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

