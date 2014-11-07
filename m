Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKGMpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:45:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:8196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaKGMpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:45:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,332,1413270000"; 
   d="scan'208";a="618821180"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: [PATCH 0/2] Add SPI support for Diolan DLN2
Date: Fri,  7 Nov 2014 14:45:12 +0200
Message-Id: <1415364314-30320-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for the SPI module of the Diolan DLN2 USB to
I2C/SPI/GPIO bridge [1].

This patch depends on another patchset, [1], not yet merged, which adds support
for the other two modules: I2C and GPIO.

[1] http://www.diolan.com/products/dln2/features.html
[2] http://marc.info/?l=linux-kernel&m=141528172903850&w=2

laurentiu

Laurentiu Palcu (2):
  spi: add support for DLN-2 USB-SPI adapter
  mfd: dln2: add support for USB-SPI module

 drivers/mfd/dln2.c     |  12 +
 drivers/spi/Kconfig    |  10 +
 drivers/spi/Makefile   |   1 +
 drivers/spi/spi-dln2.c | 795 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 818 insertions(+)
 create mode 100644 drivers/spi/spi-dln2.c

-- 
1.9.1

