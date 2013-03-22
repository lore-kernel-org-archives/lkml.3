Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab3CVKWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:22:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216Ab3CVKWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:22:51 -0400
Date: Fri, 22 Mar 2013 11:22:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.9
Message-ID: <20130322102244.GB30807@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the fixes below.

Thanks.

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/for_linus

for you to fetch changes up to 9713faecff3d071de1208b081d4943b002e9cb1c:

  EDAC: Merge mci.mem_is_per_rank with mci.csbased (2013-03-16 06:32:30 +0100)

----------------------------------------------------------------
A fix from Mauro to correct csrow size accounting in sysfs and a sparse
fix from Stephen Hemminger.

----------------------------------------------------------------
Mauro Carvalho Chehab (2):
      amd64_edac: Correct DIMM sizes
      EDAC: Merge mci.mem_is_per_rank with mci.csbased

Stephen Hemminger (1):
      EDAC: Make sysfs functions static

 drivers/edac/amd64_edac.c    | 15 +++++++++------
 drivers/edac/edac_mc.c       |  6 +++---
 drivers/edac/edac_mc_sysfs.c | 17 +++++------------
 include/linux/edac.h         |  7 ++-----
 4 files changed, 19 insertions(+), 26 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
