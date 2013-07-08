Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3GHOmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:42:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3GHOmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:42:05 -0400
Date: Mon, 8 Jul 2013 16:42:02 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] ext3 fix & quota cleanup
Message-ID: <20130708144202.GB12743@quack.suse.cz>
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

to get a fix of ext3 error reporting from fsync and a quota cleanup.

Top of the tree is e628753. The full shortlog is:

Dmitry Monakhov (1):
      ext3: Fix fsync error handling after filesystem abort.

Joe Perches (1):
      quota: Convert use of typedef ctl_table to struct ctl_table

The diffstat is

 fs/ext3/fsync.c  |  8 ++++++--
 fs/ext3/super.c  | 13 ++++++++++++-
 fs/quota/dquot.c |  6 +++---
 3 files changed, 21 insertions(+), 6 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
