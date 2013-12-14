Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3LNKMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 05:12:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab3LNKL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 05:11:59 -0500
Date: Sat, 14 Dec 2013 11:11:44 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS for 3.14
Message-ID: <20131214101144.GA21353@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please queue for 3.14.

Thanks.

--
The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/ras_for_3.14

for you to fetch changes up to 42139eb356e3384759ca143ae04d82376346eb4c:

  ACPI, eMCA: Combine eMCA/EDAC event reporting priority (2013-12-11 19:04:37 +0100)

----------------------------------------------------------------
* Add the functionality to override error reporting agents as some
machines are sporting a new extended error logging capability which, if
done properly in the BIOS, makes a corresponding EDAC module redundant,
from Gong Chen.

* PCIe AER tracepoint severity levels fix, from Rui Wang.

* Error path correction for the mce device init, from Levente Kurusa.

----------------------------------------------------------------
Chen, Gong (3):
      EDAC: Add an edac_report parameter to EDAC
      EDAC, sb_edac: Modify H/W event reporting policy
      ACPI, eMCA: Combine eMCA/EDAC event reporting priority

Levente Kurusa (1):
      x86, mce: Call put_device on device_register failure

Rui Wang (1):
      PCI, AER: Fix severity usage in aer trace event

 Documentation/kernel-parameters.txt |  8 ++++++++
 arch/x86/kernel/cpu/mcheck/mce.c    |  4 +++-
 drivers/acpi/acpi_extlog.c          | 18 ++++++++++++++++--
 drivers/edac/edac_stub.c            | 19 +++++++++++++++++++
 drivers/edac/sb_edac.c              |  6 +++++-
 include/linux/edac.h                | 28 ++++++++++++++++++++++++++++
 include/trace/events/ras.h          | 10 +++++-----
 7 files changed, 84 insertions(+), 9 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
