Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3HLUDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:03:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58526 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3HLUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:03:07 -0400
Date: Mon, 12 Aug 2013 22:03:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AMD F15h, model 0x30 stuff for 3.12
Message-ID: <20130812200305.GK18018@pd.tnic>
References: <20130810184627.GB6189@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130810184627.GB6189@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here's the properly based-off version; please pull.

Thanks.

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/amd_f15_m30

for you to fetch changes up to a4b4bedce880046feeb5b206392960f395ed02ad:

  amd64_edac: Get rid of boot_cpu_data accesses (2013-08-12 16:01:56 +0200)

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

 arch/x86/kernel/amd_nb.c  |  13 ++++-
 drivers/edac/amd64_edac.c | 324 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h |  60 ++++++++++++++++++--
 include/linux/pci_ids.h   |   2 +
 4 files changed, 322 insertions(+), 77 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
