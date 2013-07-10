Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3GJP16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:27:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24706 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3GJP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:27:57 -0400
Message-ID: <51DD7D70.5020307@oracle.com>
Date: Wed, 10 Jul 2013 10:27:44 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "jfs-discussion@lists.sourceforge.net" 
	<jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] JFS updates for 3.11
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4d3797d7e1861ac1af150a6189315786c5e1c820:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-05 19:19:04 +0900)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.11

for you to fetch changes up to eb8630d7d2fd13589e6a7a3ae2fe1f75f867fbed:

  jfs: Update jfs_error (2013-06-05 14:47:19 -0500)

----------------------------------------------------------------
A couple cleanups to JFS for 3.11

----------------------------------------------------------------
Dave Kleikamp (1):
      jfs: fix sparse warning in fs/jfs/xattr.c

Joe Perches (1):
      jfs: Update jfs_error

 fs/jfs/jfs_dmap.c       | 70 +++++++++++++++++++------------------------------
 fs/jfs/jfs_dtree.c      | 37 +++++++++++++-------------
 fs/jfs/jfs_extent.c     |  2 +-
 fs/jfs/jfs_imap.c       | 69 ++++++++++++++++++++----------------------------
 fs/jfs/jfs_metapage.c   |  5 ++--
 fs/jfs/jfs_superblock.h |  1 +
 fs/jfs/jfs_txnmgr.c     |  2 +-
 fs/jfs/jfs_xtree.c      | 62 +++++++++++++++++++++----------------------
 fs/jfs/namei.c          |  2 +-
 fs/jfs/resize.c         |  2 +-
 fs/jfs/super.c          | 22 +++++++++-------
 fs/jfs/xattr.c          |  8 +++---
 12 files changed, 128 insertions(+), 154 deletions(-)
