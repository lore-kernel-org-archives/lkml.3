Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaCGGKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:10:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:51678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaCGGKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:10:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="scan'208";a="493970227"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] i2c: designware-pci: extra features for PCI mode LPSS I2C
Date: Fri,  7 Mar 2014 22:12:49 +0800
Message-Id: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

These two patches contains the additional changes required for BayTrail LPSS
I2C on top of the patch that Mika Westerberg has submitted previously which
is still in the pending queue:
"[PATCH v2] i2c: designware-pci: Add Baytrail PCI IDs"
http://www.spinics.net/lists/linux-i2c/msg14709.html

Basically, the changes inclusive of:
i.	enable the pci glue layer to pass in target HCNT, LCNT
	and SDA hold time values to core layer if they are known
	beforehand, eg: for BayTrail.
ii.	declare the BayTrail LPSS I2C controllers are capable of
	supporting 10-bit addressing mode functionality.

Chew, Chiau Ee (2):
  i2c: designware-pci: add 10-bit addressing mode functionality for BYT
    I2C
  i2c: designware-pci: set ideal HCNT, LCNT and SDA hold time value

 drivers/i2c/busses/i2c-designware-pcidrv.c |   51 ++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 6 deletions(-)

-- 
1.7.4.4

