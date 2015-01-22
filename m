Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbbAVUwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:52:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:27748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbbAVUwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:52:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="516232798"
From: Todd Brandt <todd.e.brandt@linux.intel.com>
To: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: todd.e.brandt@linux.intel.com, todd.e.brandt@intel.com,
        jacob.jun.pan@linux.intel.com, sameo@linux.intel.com,
        lee.jones@linaro.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com
Subject: [PATCH v2 0/3] X-Power AXP288 PMIC Fuel Gauge Driver
Date: Thu, 22 Jan 2015 12:52:04 -0800
Message-Id: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New power_supply driver at driver/power which interfaces with the
axp20x mfd driver as a cell. Provides battery info, monitors for
changes, and generates alerts on temperature and capacity issues

Todd Brandt (3):
  mfd/axp20x: change battery cell name to fuel gauge
  mfd/axp20x: add support for fuel gauge cell
  X-Power AXP288 PMIC Fuel Gauge Driver

 drivers/mfd/axp20x.c              |    8 +-
 drivers/power/Kconfig             |    9 +
 drivers/power/Makefile            |    1 +
 drivers/power/axp288_fuel_gauge.c | 1148 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/axp20x.h        |   43 +-
 5 files changed, 1203 insertions(+), 6 deletions(-)
 create mode 100644 drivers/power/axp288_fuel_gauge.c

-- 
2.1.0

