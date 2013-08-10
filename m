Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3HJSqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 14:46:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38777 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab3HJSq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 14:46:29 -0400
Date: Sat, 10 Aug 2013 20:46:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD F15h, model 0x30 stuff for 3.12
Message-ID: <20130810184627.GB6189@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull into the 3.12 queue; branch is against tip/master.

Thanks.


The following changes since commit 445363e8edc400c02c05b7bd275337f90f926910:

  Merge branch 'perf/urgent' (2013-08-05 11:32:36 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/amd_f15_m30

for you to fetch changes up to e7e1b946fdcf0c6f9e27ea3cfa322bdf4c1ac118:

  amd64_edac: Get rid of boot_cpu_data accesses (2013-08-10 20:38:07 +0200)

----------------------------------------------------------------
AMD F15h, model 0x30 and later enablement stuff, more specifically EDAC
support.

----------------------------------------------------------------
Aravind Gopalakrishnan (3):
      pci_ids: Add PCI device ID functions 3 and 4 for newer F15h models.
      x86, amd_nb: Clarify F15h, model 30h GART and L3 support
      amd64_edac: Add ECC decoding support for newer F15h models

Borislav Petkov (1):
      amd64_edac: Get rid of boot_cpu_data accesses

 arch/x86/kernel/amd_nb.c  |  13 +-
 drivers/edac/amd64_edac.c | 324 ++++++++++++++++++++++++++++++++++++----------
 drivers/edac/amd64_edac.h |  60 ++++++++-
 include/linux/pci_ids.h   |   2 +
 4 files changed, 322 insertions(+), 77 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
