Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaGKSEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:04:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:46210 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaGKSEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:04:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,644,1400050800"; 
   d="scan'208";a="571847342"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH] Documentation: Remove reference to acpi_platform_device_ids from acpi/enumeration
Date: Fri, 11 Jul 2014 11:03:39 +0000
Message-Id: <96c9e6efdd200bb194bc99845a18015f8d19881d.1405076619.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of:

    4845934 ACPI / scan: use platform bus type by default for _HID enumeration

ACPI uses the platform bus by default, changing the opt-in to an opt-out
policy, eliminating the acpi_platform_device_ids table and replacing it
with forbidden_id_list[].

Remove the qualifying paragraph from the acpi/enumeration documentation
as it no longer applies.

Reported-by: Max Eliaser <max@meliaserlow.dyndns.tv>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/acpi/enumeration.txt | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index fd786ea..e182be5 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -60,12 +60,6 @@ If the driver needs to perform more complex initialization like getting and
 configuring GPIOs it can get its ACPI handle and extract this information
 from ACPI tables.
 
-Currently the kernel is not able to automatically determine from which ACPI
-device it should make the corresponding platform device so we need to add
-the ACPI device explicitly to acpi_platform_device_ids list defined in
-drivers/acpi/acpi_platform.c. This limitation is only for the platform
-devices, SPI and I2C devices are created automatically as described below.
-
 DMA support
 ~~~~~~~~~~~
 DMA controllers enumerated via ACPI should be registered in the system to
-- 
2.0.0

