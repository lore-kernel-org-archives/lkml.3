Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3GDRnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:43:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab3GDRnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:43:08 -0400
Date: Thu, 4 Jul 2013 19:43:04 +0200
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Rebased for_next branch in my linux-fs git tree
Message-ID: <20130704174304.GA30265@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Stephen,

  I'm just writing this to let you know that I had to rebase for_next
branch in my linux-fs git tree because I've messed up my tree and for_linus
& for_next branches contained the same patches but with different commit
IDs (fast track fixes). When I pulled for_next into for_linus branch,
the changelog had commit logs for those patches twice which was rather
confusing. The only solution I found was to rebase for_next on top of
for_linus to get rid of the duplicate patches. If there's a cleaner
solution of the situation, I'm happy to learn it for future...

This is just that you know what's going on when you are doing your merge
window statistics :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
