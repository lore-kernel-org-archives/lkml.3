Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaBHMrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 07:47:04 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33739 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBHMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 07:47:02 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 1/2] ACPI / processor: Replace hard-coded "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID
Date: Sat,  8 Feb 2014 20:46:25 +0800
Message-Id: <1391863586-3157-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID to improve code
readability.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index a4eea9a..849cfd6 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -390,5 +390,6 @@ void __init acpi_early_processor_set_pdc(void)
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
-	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
+	acpi_get_devices(ACPI_PROCESSOR_DEVICE_HID,
+				early_init_pdc, NULL, NULL);
 }
-- 
1.7.9.5

