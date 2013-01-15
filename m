Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3AOSaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:30:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3AOSaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:30:00 -0500
Date: Tue, 15 Jan 2013 19:29:58 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] ext3 & udf fix
Message-ID: <20130115182958.GA23603@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get one ext3 performance regression fix and one udf regression fix (oops
on interrupted mount).

Top of the tree is 1b1baff. The full shortlog is:

Eric Sandeen (1):
      jbd: don't wake kjournald unnecessarily

Namjae Jeon (1):
      UDF: Fix a null pointer dereference in udf_sb_free_partitions

The diffstat is

 fs/jbd/journal.c |    3 ++-
 fs/udf/super.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

							Thanks
								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
