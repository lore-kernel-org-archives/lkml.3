Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaD3CF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:05:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:23465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbaD3CFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="503428513"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 09/27] ACPICA: Comment updates - no functional change.
Date: Wed, 30 Apr 2014 10:04:28 +0800
Message-Id: <8df8575ba09810fe9a419c97c4284c52cefaf453.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Change all instances of "sub-table" to "subtable" for
consistency.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl1.h |    4 ++--
 include/acpi/actbl2.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 212c65d..4ad7da8 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -675,7 +675,7 @@ enum acpi_madt_type {
 };
 
 /*
- * MADT Sub-tables, correspond to Type in struct acpi_subtable_header
+ * MADT Subtables, correspond to Type in struct acpi_subtable_header
  */
 
 /* 0: Processor Local APIC */
@@ -918,7 +918,7 @@ enum acpi_srat_type {
 };
 
 /*
- * SRAT Sub-tables, correspond to Type in struct acpi_subtable_header
+ * SRAT Subtables, correspond to Type in struct acpi_subtable_header
  */
 
 /* 0: Processor Local APIC/SAPIC Affinity */
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 6874261..860e5c8 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -457,7 +457,7 @@ struct acpi_dmar_pci_path {
 };
 
 /*
- * DMAR Sub-tables, correspond to Type in struct acpi_dmar_header
+ * DMAR Subtables, correspond to Type in struct acpi_dmar_header
  */
 
 /* 0: Hardware Unit Definition */
@@ -885,7 +885,7 @@ struct acpi_lpit_io {
 
 /*******************************************************************************
  *
- * MCFG - PCI Memory Mapped Configuration table and sub-table
+ * MCFG - PCI Memory Mapped Configuration table and subtable
  *        Version 1
  *
  * Conforms to "PCI Firmware Specification", Revision 3.0, June 20, 2005
@@ -988,7 +988,7 @@ enum acpi_slic_type {
 };
 
 /*
- * SLIC Sub-tables, correspond to Type in struct acpi_slic_header
+ * SLIC Subtables, correspond to Type in struct acpi_slic_header
  */
 
 /* 0: Public Key Structure */
-- 
1.7.10

