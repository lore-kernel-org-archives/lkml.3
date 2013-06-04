Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3FDV4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:56:43 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:43410 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3FDV4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:56:41 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Remove unused flags in acpi_device_flags
Date: Tue,  4 Jun 2013 15:56:25 -0600
Message-Id: <1370382985-12163-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suprise_removal_ok and performance_manageable in struct
acpi_device_flags are not used by any code.  So, remove
them.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 include/acpi/acpi_bus.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 1a681ee..9efc52f 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -156,12 +156,10 @@ struct acpi_device_flags {
 	u32 dynamic_status:1;
 	u32 removable:1;
 	u32 ejectable:1;
-	u32 suprise_removal_ok:1;
 	u32 power_manageable:1;
-	u32 performance_manageable:1;
 	u32 eject_pending:1;
 	u32 match_driver:1;
-	u32 reserved:24;
+	u32 reserved:26;
 };
 
 /* File System */
