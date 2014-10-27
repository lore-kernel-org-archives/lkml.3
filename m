Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJ0FYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:24:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:28317 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaJ0FUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:20:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497683"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch v7 06/18] ACPI: Fix minor syntax issues in processor_core.c
Date: Mon, 27 Oct 2014 13:21:36 +0800
Message-Id: <1414387308-27148-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix minor syntax issues in processor_core.c to follow coding styles.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/processor_core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ef58f46c8442..342942f90a10 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -125,13 +125,12 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 	}
 
 	header = (struct acpi_subtable_header *)obj->buffer.pointer;
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
 		map_lapic_id(header, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
 		map_lsapic_id(header, type, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC)
 		map_x2apic_id(header, type, acpi_id, &apic_id);
-	}
 
 exit:
 	kfree(buffer.pointer);
@@ -164,7 +163,7 @@ int acpi_map_cpuid(int apic_id, u32 acpi_id)
 		 * For example,
 		 *
 		 * Scope (_PR)
-                 * {
+		 * {
 		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
 		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
 		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
-- 
1.7.10.4

