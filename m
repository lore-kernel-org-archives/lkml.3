Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaHUTon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:44:43 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58979 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaHUTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:44:42 -0400
Date: Thu, 21 Aug 2014 14:44:29 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.17-rc1
Message-ID: <20140821194429.GC6168@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing drastic but pushing out early due to build breakage in the new
tegra platform.

* M550 tagged trim blacklist pattern is widened so that it matches the
  new 1TB model.

* The other three are controller specific fixes.

Thanks.

The following changes since commit 88ec63d6f85ccf40988ddae8b430dcb07355b29b:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2014-08-15 18:28:58 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.17-fixes

for you to fetch changes up to 2a13772a144d2956a7fedd18685921d0a9b8b783:

  libata: widen Crucial M550 blacklist matching (2014-08-18 17:40:09 -0400)

----------------------------------------------------------------
Arjun Sreedharan (2):
      pata_samsung_cf: change ret type to signed
      pata_scc: propagate return value of scc_wait_after_reset

Mikko Perttunen (1):
      ata: ahci_tegra: Change include to fix compilation

Suman Tripathi (1):
      ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host Controller driver.

Tejun Heo (1):
      libata: widen Crucial M550 blacklist matching

 drivers/ata/ahci_tegra.c      |  2 +-
 drivers/ata/ahci_xgene.c      |  4 ++--
 drivers/ata/libata-core.c     |  2 +-
 drivers/ata/pata_samsung_cf.c |  2 +-
 drivers/ata/pata_scc.c        | 15 +++++++--------
 5 files changed, 12 insertions(+), 13 deletions(-)

-- 
tejun
