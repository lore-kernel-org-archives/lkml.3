Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaHTWcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:32:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbaHTWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:32:40 -0400
Date: Thu, 21 Aug 2014 00:32:33 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [GIT PULL] FS bugfixes for 3.17-rc2
Message-ID: <20140820223233.GA6477@quack.suse.cz>
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

to get udf, isofs, and ext3 bug fix.

Top of the tree is e6d8fb340f20. The full shortlog is:

Chao Yu (1):
      udf: avoid unneeded up_write when fail to add entry in ->symlink

Chin-Tsung Cheng (1):
      ext3: Count internal journal as bsddf overhead in ext3_statfs

Jan Kara (1):
      isofs: Fix unbounded recursion when processing relocated directories

The diffstat is

 fs/ext3/super.c  |  5 +++--
 fs/isofs/inode.c | 15 ++++++++-------
 fs/isofs/isofs.h | 23 +++++++++++++++++++----
 fs/isofs/rock.c  | 39 ++++++++++++++++++++++++++++-----------
 fs/udf/namei.c   |  3 ++-
 5 files changed, 60 insertions(+), 25 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
