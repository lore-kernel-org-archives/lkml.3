Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3B0XGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:06:49 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15154 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab3B0XGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:06:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Feb 2013 15:01:21 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 0/4] Add support for tps65090-charger
Date: Wed, 27 Feb 2013 18:07:26 -0500
Message-ID: <1362006450-4979-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the TPS65090-charger. This charger is
registered as a subdevice of the TPS65090 PMIC.

This series includes a fix for the tps65090 header file where all
the interrupts were shifted by 1.

Rhyland Klein (4):
  mfd: tps65090: Fix enum in header file
  mfd: tps65090: Add resources for charger
  power_supply: tps65090-charger: Add binding doc
  power: tps65090: Add support for tps65090-charger

 .../devicetree/bindings/power_supply/tps65090.txt  |   23 ++
 drivers/mfd/tps65090.c                             |   10 +
 drivers/power/Kconfig                              |    7 +
 drivers/power/Makefile                             |    1 +
 drivers/power/tps65090-charger.c                   |  310 ++++++++++++++++++++
 include/linux/mfd/tps65090.h                       |    6 +
 6 files changed, 357 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/tps65090.txt
 create mode 100644 drivers/power/tps65090-charger.c

-- 
1.7.9.5

