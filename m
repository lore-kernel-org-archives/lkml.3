Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3IZWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:03:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3IZWDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:03:31 -0400
Date: Fri, 27 Sep 2013 00:03:29 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Reiserfs and UDF fixes
Message-ID: <20130926220329.GA29568@quack.suse.cz>
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

The pull contains fix of an UDF oops when mounting corrupted media and a
fix of a race in reiserfs leading to oops.

Top of the tree is 721a769. The full shortlog is:

Jan Kara (1):
      udf: Fortify LVID loading

Jeff Mahoney (2):
      reiserfs: remove useless flush_old_journal_lists
      reiserfs: fix race with flush_used_journal_lists and flush_journal_list

The diffstat is

 fs/reiserfs/journal.c | 67 +++------------------------------------------------
 fs/udf/ialloc.c       | 16 ++++++------
 fs/udf/super.c        | 64 ++++++++++++++++++++++++++++++------------------
 fs/udf/udf_sb.h       |  2 +-
 4 files changed, 52 insertions(+), 97 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
