Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaAWSdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:33:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbaAWSdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:33:13 -0500
Date: Thu, 23 Jan 2014 19:33:10 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] UDF & jbd fixes
Message-ID: <20140123183310.GE28796@quack.suse.cz>
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

to get a cleanup of JBD log messages and UDF fix of a lockdep warning.

Top of the tree is 4ea7772f828a. The full shortlog is:

Jan Kara (2):
      jbd: Revise KERN_EMERG error messages
      udf: Fix lockdep warning from udf_symlink()

The diffstat is

 fs/jbd/journal.c     | 8 +++-----
 fs/jbd/transaction.c | 4 ++--
 fs/udf/namei.c       | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
