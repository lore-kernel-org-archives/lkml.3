Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaAaPKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:10:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24064 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaAaPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:10:22 -0500
Message-ID: <52EBBCD1.7030703@oracle.com>
Date: Fri, 31 Jan 2014 09:10:09 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>
Subject: [GIT PULL] jfs for 3.14
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a0bb2966efbf30a71c128c3af63307d8b5f5fc0:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2014-01-01 11:36:16 -0800)

are available in the git repository at:


  git://github.com/kleikamp/linux-shaggy.git tags/jfs-3.14

for you to fetch changes up to 0439e091e3b1fe41a350540c84857a573fde3d72:

  jfs: fix xattr value size overflow in __jfs_setxattr (2014-01-02 11:36:56 -0600)

----------------------------------------------------------------
Minor bug fix for linux-3.14

----------------------------------------------------------------
Jie Liu (1):
      jfs: fix xattr value size overflow in __jfs_setxattr

 fs/jfs/xattr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)
