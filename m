Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaICCnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:43:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:16451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaICCnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="380612102"
From: Raymond Tan <raymond.tan@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Romain Baeriswyl <romainba@abilis.com>
Subject: [PATCH 0/1] i2c: designware: Add support for Intel Quark X1000
Date: Wed,  3 Sep 2014 10:41:37 +0800
Message-Id: <1409712098-13997-1-git-send-email-raymond.tan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tan, Raymond" <raymond.tan@intel.com>

Hi,
This patch is for enabling support of Intel Quark X1000 i2c controller. The
Quark designware i2c controller is registered as a MFD device, and Quark
exports a single PCI device with both I2C and GPIO functions.

In Quark, there is currently no other configuration mechanism other than
board files to configure the I2C mode for the the controller.

This patch is built upon the changes made by Romain Baeriswyl, titled
[PATCH V3 2/2] i2c designware add support of I2C standard mode, at
https://lkml.org/lkml/2014/3/25/135

Tan, Raymond (1):
  i2c: designware: add support of platform data to set I2C mode

 drivers/i2c/busses/i2c-designware-platdrv.c  |    6 ++++++
 include/linux/platform_data/i2c-designware.h |   21 +++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 include/linux/platform_data/i2c-designware.h

-- 
1.7.9.5

