Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab3AQKbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:31:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:41319 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759528Ab3AQKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:30:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="245018587"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] i2c-designware: add Intel Lynxpoint support
Date: Thu, 17 Jan 2013 12:31:03 +0200
Message-Id: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series adds support for the Intel Lynxpoint Low Power Subsystem I2C
controllers. They are compatible with the DesignWare I2C controller.

Patches [1/4] and [2/4] are fixes that are necessary to get the driver
working on Lynxpoint.

Patch [3/4] brings minimal runtime PM support for the designware platform
driver. This is useful if the PM subsystem/domain implements runtime PM,
like in case of ACPI.

Patch [4/4] finally implements ACPI enumeration support for the designware
platform driver and adds Lynxpoint ACPI IDs.

Please review.

Mika Westerberg (4):
  i2c-designware: add missing MODULE_LICENSE
  i2c-designware: always set the STOP bit after last byte
  i2c-designware: add minimal support for runtime PM
  i2c-designware: add support for Intel Lynxpoint

 drivers/i2c/busses/i2c-designware-core.c    |   20 ++++++++-
 drivers/i2c/busses/i2c-designware-platdrv.c |   59 +++++++++++++++++++++++++--
 2 files changed, 74 insertions(+), 5 deletions(-)

-- 
1.7.10.4

