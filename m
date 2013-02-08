Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3BHOFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:05:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:14246 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353Ab3BHOFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:05:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="200119550"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Landley <rob@landley.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] Documentation / acpi: refer to correct file for acpi_platform_device_ids[] table
Date: Fri,  8 Feb 2013 16:07:01 +0200
Message-Id: <1360332421-32140-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ACPI platform device code was converted to the new ACPI scan
handler facility, the the acpi_platform_device_ids[] was moved to
drivers/acpi/acpi_platform.c. Update the documentation accordingly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 Documentation/acpi/enumeration.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index 54469bc..94a6561 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -63,8 +63,8 @@ from ACPI tables.
 Currently the kernel is not able to automatically determine from which ACPI
 device it should make the corresponding platform device so we need to add
 the ACPI device explicitly to acpi_platform_device_ids list defined in
-drivers/acpi/scan.c. This limitation is only for the platform devices, SPI
-and I2C devices are created automatically as described below.
+drivers/acpi/acpi_platform.c. This limitation is only for the platform
+devices, SPI and I2C devices are created automatically as described below.
 
 SPI serial bus support
 ~~~~~~~~~~~~~~~~~~~~~~
-- 
1.7.10.4

