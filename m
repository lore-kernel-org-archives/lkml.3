Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaKLNis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:38:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:43860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaKLNir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:38:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,369,1413270000"; 
   d="scan'208";a="635695043"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: [PATCH v2 0/2] Add SPI support for Diolan DLN2
Date: Wed, 12 Nov 2014 15:38:08 +0200
Message-Id: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
 * fixed an indentation issue;
 * removed redundant call to spi_master_put() in _remove();

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
 drivers/spi/spi-dln2.c | 793 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 816 insertions(+)
 create mode 100644 drivers/spi/spi-dln2.c

-- 
1.9.1

