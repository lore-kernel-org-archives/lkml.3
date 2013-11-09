Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3KIWRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 17:17:36 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51531 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3KIWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 17:17:35 -0500
Date: Sun, 10 Nov 2013 07:17:31 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.13-rc1
Message-ID: <20131109221731.GB24275@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing too interesting.  Only two minor fixes in libata core.  Most
changes are specific to hardware which isn't too common.

The patches are available in the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.13

for you to fetch changes up to 9f961a5f6efc87a79571d7166257b36af28ffcfe:

  ahci: Add Device IDs for Intel Wildcat Point-LP (2013-11-04 16:03:39 -0500)

Thanks.

----------------------------------------------------------------
Chuansheng Liu (1):
      ahci: Changing two module params with static and __read_mostly

Dan Carpenter (1):
      sata_highbank: clear whole array in highbank_initialize_phys()

Gwendal Grignou (1):
      libata: Fix display of sata speed

James Ralston (1):
      ahci: Add Device IDs for Intel Wildcat Point-LP

Laurent Pinchart (1):
      sata_rcar: Convert to clk_prepare/unprepare

Levente Kurusa (1):
      ata_piix: minor typo and a printk fix

Richard Zhu (1):
      ahci: imx: setup power saving methods

Robert Hancock (1):
      libata: Add some missing command descriptions

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset

 drivers/ata/ahci.c             |   4 ++
 drivers/ata/ahci.h             |   2 +
 drivers/ata/ahci_imx.c         | 101 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/ahci_platform.c    |   3 +-
 drivers/ata/ata_piix.c         |  19 ++++----
 drivers/ata/libahci.c          |  27 +++++++++--
 drivers/ata/libata-core.c      |   1 +
 drivers/ata/libata-eh.c        |   8 ++++
 drivers/ata/libata-transport.c |  16 +++----
 drivers/ata/sata_highbank.c    |   8 ++--
 drivers/ata/sata_rcar.c        |  10 ++--
 include/linux/ata.h            |   7 +++
 12 files changed, 171 insertions(+), 35 deletions(-)

-- 
tejun
