Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3DPL0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:26:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3DPL0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:26:03 -0400
Date: Tue, 16 Apr 2013 13:25:54 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: schwab@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fix for v3.9
Message-ID: <20130416112554.GA18585@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this fix for a missing dependency when generating
scripts/mod/devicetable-offsets.h. This dependency got introduced in
v3.9-rc1.

Thanks,
Michal

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to a54292f58fc16e3d09aecea16de3e58a898dde97:

  kbuild: generate generic headers before recursing into scripts (2013-04-10 09:55:34 +0200)

----------------------------------------------------------------
Andreas Schwab (1):
      kbuild: generate generic headers before recursing into scripts

 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
