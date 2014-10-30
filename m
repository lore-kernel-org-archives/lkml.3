Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaJaIXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:23:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaJaIX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:23:27 -0400
Date: Thu, 30 Oct 2014 19:20:10 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.orh,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Quota and ext3 fixes for 3.18-rc3
Message-ID: <20141030182010.GK28444@quack.suse.cz>
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

  to get the following minor ext3 & quota fixes.

Top of the tree is 3c9cafe05ff0. The full shortlog is:

Jan Kara (2):
      ext3: Don't check quota format when there are no quota files
      quota: Properly return errors from dquot_writeback_dquots()

Sasha Levin (1):
      fs, jbd: use a more generic hash function

The diffstat is

 fs/ext3/super.c  | 7 -------
 fs/jbd/revoke.c  | 7 ++-----
 fs/quota/dquot.c | 2 +-
 3 files changed, 3 insertions(+), 13 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
