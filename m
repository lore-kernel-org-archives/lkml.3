Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaFDM7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:59:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48012 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaFDM7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:59:11 -0400
Message-ID: <538F180F.2090905@oracle.com>
Date: Wed, 04 Jun 2014 07:58:55 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: JFS Discussion <jfs-discussion@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] jfs changes for 3.16
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Please pull the following for 3.16.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.16

for you to fetch changes up to bb5e50aaa80564268f950d1b2f764455afbfea82:

  fs/jfs/super.c: convert simple_str to kstr (2014-06-03 14:14:00 -0500)

----------------------------------------------------------------
jfs patches for 3.16

----------------------------------------------------------------
Fabian Frederick (5):
      fs/jfs/jfs_inode.c: atomically set inode->i_flags
      fs/jfs/jfs_logmgr.c: remove NULL assignment on static
      fs/jfs/super.c: remove 0 assignment to static + code clean-up
      fs/jfs/jfs_dmap.c: replace min/casting by min_t
      fs/jfs/super.c: convert simple_str to kstr

William Burrow (1):
      JFS: Check for NULL before calling posix_acl_equiv_mode()

 fs/jfs/acl.c        | 16 ++++++-----
 fs/jfs/jfs_dmap.c   |  9 ++++---
 fs/jfs/jfs_inode.c  | 16 +++++------
 fs/jfs/jfs_logmgr.c |  2 +-
 fs/jfs/super.c      | 77 ++++++++++++++++++++++++++++++-----------------------
 5 files changed, 66 insertions(+), 54 deletions(-)
