Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaIHA7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 20:59:50 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42844 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaIHA7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 20:59:48 -0400
Date: Mon, 8 Sep 2014 09:59:44 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.17-rc4
Message-ID: <20140908005944.GD5061@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two patches are to add PCI IDs for ICH9 and all others are device
specific fixes.  Nothing too interesting.

Thanks.

The following changes since commit 2a13772a144d2956a7fedd18685921d0a9b8b783:

  libata: widen Crucial M550 blacklist matching (2014-08-18 17:40:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.17-fixes

for you to fetch changes up to 0babe614b6b4c7d1d8e12d7a6dbdac6e2f0df8e2:

  ahci_xgene: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver. (2014-09-06 11:27:15 +0900)

----------------------------------------------------------------
Chuansheng Liu (1):
      ata: Disabling the async PM for JMicron chip 363/361

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Mikko Perttunen (1):
      ata: ahci_tegra: Read calibration fuse

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

Suman Tripathi (2):
      ahci_xgene: Skip the PHY and clock initialization if already configured by the firmware.
      ahci_xgene: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver.

 drivers/ata/ahci.c         | 22 +++++++++++++++++
 drivers/ata/ahci_tegra.c   | 14 ++++++++---
 drivers/ata/ahci_xgene.c   | 61 +++++++++++++++++++++++++++++++++++-----------
 drivers/ata/ata_piix.c     |  8 ++++++
 drivers/ata/pata_jmicron.c | 12 +++++++++
 5 files changed, 99 insertions(+), 18 deletions(-)

-- 
tejun
