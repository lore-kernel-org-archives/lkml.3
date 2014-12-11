Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbaLKJoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:44:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:13059 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbaLKJoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:44:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,556,1413270000"; 
   d="scan'208";a="622089364"
From: Raymond Tan <raymond.tan@intel.com>
To: Lee Jones <lee.jones@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alvin Chen <alvin.chen@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Raymond Tan <raymond.tan@intel.com>
Subject: [PATCH v3 0/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000 I2C-GPIO MFD Driver
Date: Thu, 11 Dec 2014 17:38:29 +0800
Message-Id: <1418290710-5871-1-git-send-email-raymond.tan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tan, Raymond" <raymond.tan@intel.com>

Hi,
This patch is for enabling support of Intel Quark X1000 I2C controller and
GPIO controller. In Quark X1000, the platform exports a single PCI device
with both I2C and GPIO functions.

This MFD driver will split the 2 devices for their respective drivers.

---
Changes in v3:
* Simplify the call path for both gpio and i2c controllers initialization
* Move the global variables clk and clk_lookup into a struct

Changes in v2:
* Fix possible memory leak

Raymond Tan (1):
  mfd: intel_quark_i2c_gpio: Add Intel Quark X1000 I2C-GPIO MFD Driver

 drivers/mfd/Kconfig                |   12 ++
 drivers/mfd/Makefile               |    1 +
 drivers/mfd/intel_quark_i2c_gpio.c |  279 ++++++++++++++++++++++++++++++++++++
 3 files changed, 292 insertions(+)
 create mode 100644 drivers/mfd/intel_quark_i2c_gpio.c

-- 
1.7.9.5

