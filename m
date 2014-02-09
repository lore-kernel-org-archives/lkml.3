Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaBIJNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:13:32 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60457 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBIJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:13:27 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [Update][PATCH 1/2] ACPI / processor: Replace hard-coded "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID
Date: Sun,  9 Feb 2014 17:12:27 +0800
Message-Id: <1391937147-5250-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "ACPI0007" with ACPI_PROCESSOR_DEVICE_HID to improve code
readability.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index a4eea9a..f31d0fb 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -390,5 +390,5 @@ void __init acpi_early_processor_set_pdc(void)
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
-	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
+	acpi_get_devices(ACPI_PROCESSOR_DEVICE_HID, early_init_pdc, NULL, NULL);
 }
-- 
1.7.9.5

