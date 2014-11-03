Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaKCHmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:42:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:10941 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaKCHmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:42:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="410233747"
From: Raymond Tan <raymond.tan@intel.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alvin Chen <alvin.chen@intel.com>,
        Raymond Tan <raymond.tan@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH 0/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000 I2C-GPIO MFD Driver
Date: Mon,  3 Nov 2014 15:39:03 +0800
Message-Id: <1415000344-23575-1-git-send-email-raymond.tan@intel.com>
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

Raymond Tan (1):
  mfd: intel_quark_i2c_gpio: Add Intel Quark X1000 I2C-GPIO MFD Driver

 drivers/mfd/Kconfig                |   11 ++
 drivers/mfd/Makefile               |    1 +
 drivers/mfd/intel_quark_i2c_gpio.c |  298 ++++++++++++++++++++++++++++++++++++
 3 files changed, 310 insertions(+)
 create mode 100644 drivers/mfd/intel_quark_i2c_gpio.c

-- 
1.7.9.5

