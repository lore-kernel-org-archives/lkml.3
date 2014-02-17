Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaBQF6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:58:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:45882 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaBQF6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:58:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="341486027"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] IA64: fix warning in make defconfig
Date: Mon, 17 Feb 2014 13:59:30 +0800
Message-Id: <1392616774-8620-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the ACPI container and ACPI PCI hotplug driver has been converted
as built-in modules, so reflect these changes in IA64 defconfig file.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/ia64/configs/generic_defconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index efbd292..6404acb 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -30,9 +30,9 @@ CONFIG_ACPI_BUTTON=m
 CONFIG_ACPI_FAN=m
 CONFIG_ACPI_DOCK=y
 CONFIG_ACPI_PROCESSOR=m
-CONFIG_ACPI_CONTAINER=m
+CONFIG_ACPI_CONTAINER=y
 CONFIG_HOTPLUG_PCI=y
-CONFIG_HOTPLUG_PCI_ACPI=m
+CONFIG_HOTPLUG_PCI_ACPI=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
-- 
1.7.10.4

