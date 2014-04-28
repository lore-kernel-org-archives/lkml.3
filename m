Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaD1Fat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:30:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49097 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaD1Far (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:30:47 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        Keerthy <j-keerthy@ti.com>
Subject: [PATCH 0/2] TPS65917: Drivers for TPS65917 PMIC 
Date: Mon, 28 Apr 2014 10:58:24 +0530
Message-ID: <1398662906-4398-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65917 chip is a power management IC for Portable Navigation Systems
and Tablet Computing devices. It contains the following components:

 - Regulators.
 - GPADC.
 - Over Temperature warning and Shut down.

This patch series adds support for TPS65917 mfd device. At this time only
the regulator functionality is made available.

The closest drivers are PALMAS series drivers.
The register set is changed. Bit-field defenitions are changed.
Hence based on the PALMAS drivers and created a new set of drivers
with code changes as required.

The patches are boot tested on DRA7-EVM.

Keerthy (2):
  MFD: TPS65917: Add driver for the TPS65917 PMIC
  Regulators: TPS65917: Add Regulator driver for TPS65917 PMIC

 drivers/mfd/Kconfig                    |   10 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps65917.c                 |  542 ++++++++++++
 drivers/regulator/Kconfig              |   12 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65917-regulator.c |  903 +++++++++++++++++++
 include/linux/mfd/tps65917.h           | 1508 ++++++++++++++++++++++++++++++++
 7 files changed, 2977 insertions(+)
 create mode 100644 drivers/mfd/tps65917.c
 create mode 100644 drivers/regulator/tps65917-regulator.c
 create mode 100644 include/linux/mfd/tps65917.h

-- 
1.7.9.5

