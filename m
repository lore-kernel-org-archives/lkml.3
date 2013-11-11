Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3KKOep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:34:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3KKOeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:34:36 -0500
Date: Mon, 11 Nov 2013 15:34:33 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext[23], udf & quota fix
Message-ID: <20131111143433.GA24867@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get assorted fixes in quota, ext2, ext3 & udf. Probably the most
important is a fix of fs corruption issue in ext2 XIP support (OTOH xip is
rarely used).

Top of the tree is 7ba3ec5749dd. The full shortlog is:

Dan Carpenter (1):
      quota: info leak in quota_getquota()

Eric Sandeen (1):
      ext3: Count journal as bsddf overhead in ext3_statfs

Jan Kara (2):
      jbd: Revert "jbd: remove dependency on __GFP_NOFAIL"
      ext2: Fix fs corruption in ext2_get_xip_mem()

Peter A. Felvegi (1):
      udf: fix for pathetic mount times in case of invalid file system

The diffstat is

 fs/ext2/inode.c      |  2 ++
 fs/ext2/xip.c        |  1 +
 fs/ext3/super.c      |  4 ++++
 fs/jbd/transaction.c |  8 ++++----
 fs/quota/quota.c     |  1 +
 fs/udf/super.c       | 45 ++++++++++++++++++++++++++++++++++++---------
 6 files changed, 48 insertions(+), 13 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
