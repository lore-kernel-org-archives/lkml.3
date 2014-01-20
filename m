Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaATJx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:53:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaATJx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:53:57 -0500
Date: Mon, 20 Jan 2014 10:53:41 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.14
Message-ID: <20140120095341.GA3003@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a bunch of enhancements/fixes from all around the world of
EDAC.

Thanks.

--
The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.14

for you to fetch changes up to 881f0fcef9993992c24f5b649a3fb67fd4208f8f:

  EDAC: Don't try to cancel workqueue when it's never setup (2014-01-10 15:57:36 +0100)

----------------------------------------------------------------
* mpc85xx PCIe error interrupt support
* misc small enhancements/fixes all over the place.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      amd64_edac: Fix condition to verify max channels allowed for F15 M30h

Aristeu Rozanski (1):
      e752x_edac: Fix pci_dev usage count

Borislav Petkov (2):
      amd64_edac: Simplify code around decode_bus_error
      amd64_edac: Remove "amd64" prefix from static functions

Chunhe Lan (1):
      edac/85xx: Add PCIe error interrupt edac support

Jingoo Han (1):
      EDAC: Remove DEFINE_PCI_DEVICE_TABLE macro

Rashika Kheria (3):
      amd64_edac: Mark amd64_decode_bus_error as static
      EDAC: Mark edac_create_debug_nodes as static
      sb_edac: Mark get_mci_for_node_id as static

Stephen Boyd (1):
      EDAC: Don't try to cancel workqueue when it's never setup

 drivers/edac/amd64_edac.c      | 135 +++++++++++++++++++----------------------
 drivers/edac/amd76x_edac.c     |   2 +-
 drivers/edac/e752x_edac.c      |   6 +-
 drivers/edac/e7xxx_edac.c      |   2 +-
 drivers/edac/edac_device.c     |   3 +
 drivers/edac/edac_mc_sysfs.c   |   2 +-
 drivers/edac/i3000_edac.c      |   2 +-
 drivers/edac/i3200_edac.c      |   2 +-
 drivers/edac/i5000_edac.c      |   2 +-
 drivers/edac/i5100_edac.c      |   2 +-
 drivers/edac/i5400_edac.c      |   2 +-
 drivers/edac/i7300_edac.c      |   2 +-
 drivers/edac/i7core_edac.c     |   2 +-
 drivers/edac/i82443bxgx_edac.c |   2 +-
 drivers/edac/i82860_edac.c     |   2 +-
 drivers/edac/i82875p_edac.c    |   2 +-
 drivers/edac/i82975x_edac.c    |   2 +-
 drivers/edac/mpc85xx_edac.c    |  98 ++++++++++++++++++++++++++----
 drivers/edac/mpc85xx_edac.h    |   7 +++
 drivers/edac/r82600_edac.c     |   2 +-
 drivers/edac/sb_edac.c         |   4 +-
 drivers/edac/x38_edac.c        |   2 +-
 22 files changed, 181 insertions(+), 104 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
