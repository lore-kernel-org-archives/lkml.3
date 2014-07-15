Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaGOU5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:57:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbaGOU5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:57:17 -0400
Date: Tue, 15 Jul 2014 22:57:13 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Quota fix for 3.16-rc5
Message-ID: <20140715205713.GA7212@quack.suse.cz>
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

To get a fix of locking of dquot shrinker.

Top of the tree is d68aab6b8f57. The full shortlog is:

Niu Yawei (1):
      quota: missing lock in dqcache_shrink_scan()

The diffstat is

 fs/quota/dquot.c | 2 ++
 1 file changed, 2 insertions(+)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
