Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaEOHNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:13:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:51910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbaEOHNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="540765767"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, bin.yang@intel.com,
        lejun.zhu@linux.intel.com
Subject: [PATCH 0/4] mfd: Intel SoC Power Management IC
Date: Wed, 14 May 2014 22:59:34 +0800
Message-Id: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices based on Intel SoC products such as Baytrail have a Power
Management IC. In the PMIC there are subsystems for voltage regulation,
A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
Crystal Cove.

This series contains common code for these PMICs, and device specific
support for Crystal Cove.

Lejun Zhu (4):
  mfd: intel_soc_pmic: Core driver
  mfd: intel_soc_pmic: I2C interface
  mfd: intel_soc_pmic: Crystal Cove support
  mfd: intel_soc_pmic: Build files

 drivers/mfd/Kconfig                |  10 +
 drivers/mfd/Makefile               |   3 +
 drivers/mfd/intel_soc_pmic_core.c  | 543 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/intel_soc_pmic_core.h  |  83 ++++++
 drivers/mfd/intel_soc_pmic_crc.c   | 157 +++++++++++
 drivers/mfd/intel_soc_pmic_i2c.c   | 158 +++++++++++
 include/linux/mfd/intel_soc_pmic.h |  29 ++
 7 files changed, 983 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h

-- 
1.8.3.2

