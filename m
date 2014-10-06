Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaJFLAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:00:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaJFLA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:00:29 -0400
Date: Mon, 6 Oct 2014 13:00:26 +0200
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.18
Message-ID: <20141006110026.GC4372@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here's the small queue of EDAC fixes which has been accumulating.

The mpc85xx_edac fix is tagged for stable but since it got confirmed
only days before the final 3.17 release, I didn't rush a last minute
pull request to you. I hope that's ok as it will trickle down to stable
anyway and we'll make sure it lands in 3.17-stable too.

Thanks.

---
The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.18

for you to fetch changes up to a18c3f16a907b8977ef65fc8dd71ed3f7b751748:

  mpc85xx_edac: Make L2 interrupt shared too (2014-09-30 12:55:41 +0200)

----------------------------------------------------------------
Misc small fixes/improvements accumulated from the summer months,
nothing earth-shattering.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      amd64_edac: Modify usage of amd64_read_dct_pci_cfg()

Borislav Petkov (2):
      EDAC: Fix mem_types strings type
      mpc85xx_edac: Make L2 interrupt shared too

Pranith Kumar (1):
      ppc4xx_edac: Fix build error caused by wrong member access

 drivers/edac/amd64_edac.c   | 146 ++++++++++++++++++++++++--------------------
 drivers/edac/amd64_edac.h   |   5 --
 drivers/edac/edac_core.h    |   2 +-
 drivers/edac/edac_mc.c      |   2 +-
 drivers/edac/mpc85xx_edac.c |   2 +-
 drivers/edac/ppc4xx_edac.c  |   2 +-
 6 files changed, 84 insertions(+), 75 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
