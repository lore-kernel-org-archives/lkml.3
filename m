Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3HSJX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab3HSJXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:23:55 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 19 Aug 2013 10:24:03 +0100
Message-ID: <1376904243.2679.7.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

-----------------------------------------------------------------------------
Out of these five patches, the one for ensuring that the number of             
revokes is not exceeded, and the one for checking the glock is not              
already held in gfs2_getxattr are the two most important. The latter            
can be triggered by selinux.

The other three patches are very small and fix mostly fairly
trivial issues.

------------------------------------------------------------------------------
The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-07-14 21:47:51 -0700)

are available in the git repository at:

  https://git.kernel.org/cgit/linux/kernel/git/steve/gfs2-3.0-fixes.git master

Benjamin Marzinski (1):
      GFS2: don't overrun reserved revokes

Dan Carpenter (1):
      GFS2: alloc_workqueue() doesn't return an ERR_PTR

Steven Whitehouse (2):
      GFS2: Fix typo in gfs2_create_inode()
      GFS2: Check for glock already held in gfs2_getxattr

Tejun Heo (1):
      GFS2: WQ_NON_REENTRANT is meaningless and going away

 fs/gfs2/glock.c |    8 ++++----
 fs/gfs2/glops.c |   18 +++++++++++++-----
 fs/gfs2/inode.c |    6 +++++-
 fs/gfs2/main.c  |    2 +-
 4 files changed, 23 insertions(+), 11 deletions(-)


