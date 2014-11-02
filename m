Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKBK37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 05:29:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33838 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKBK3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 05:29:55 -0500
Date: Sun, 2 Nov 2014 11:29:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS fixes for 3.19
Message-ID: <20141102102951.GA5229@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please queue for 3.19.

Thanks.

---
The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/ras_for_3.19

for you to fetch changes up to 8dcf32ea220d87ca517e164de85d336480c9d172:

  x86, MCE, AMD: Assign interrupt handler only when bank supports it (2014-11-01 11:28:23 +0100)

----------------------------------------------------------------
Assortment of RAS fixes for 3.19:

* A bunch of cleanups/corrections to the AMD MCE thresholding code, from
Chen Yucong.

* Two fixes to APEI GHES and memory poisoning, respectively, from Gong Chen

----------------------------------------------------------------
Borislav Petkov (2):
      GHES: Make ghes_estatus_caches static
      x86, MCE, AMD: Drop software-defined bank in error thresholding

Chen Yucong (4):
      x86, MCE, AMD: Use macros to compute bank MSRs
      x86, MCE, AMD: Correct thresholding error logging
      x86, MCE, AMD: Move invariant code out from loop body
      x86, MCE, AMD: Assign interrupt handler only when bank supports it

Chen, Gong (2):
      APEI, GHES: Cleanup unnecessary function for lockless list
      RAS, HWPOISON: Fix wrong error recovery status

 arch/x86/include/asm/mce.h           |  1 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 54 +++++++++++++++++++-----------------
 drivers/acpi/apei/ghes.c             | 20 ++-----------
 mm/memory-failure.c                  |  2 +-
 4 files changed, 32 insertions(+), 45 deletions(-)


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
