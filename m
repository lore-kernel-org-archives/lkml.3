Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaDCMhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 08:37:46 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:65062 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaDCMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:37:43 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Grant Likely <grant.likely@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] ACPI: Update the ownership and developers for ACPI in Kconfig
Date: Thu,  3 Apr 2014 20:37:30 +0800
Message-Id: <1396528650-7402-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UEFI Forum included the ACPI spec in its portfolio in October 2013
and will host future spec iterations, following the ACPI v5.0a release.

A UEFI Forum working group named ACPI Specification Working Group (ASWG)
has been established to handle future ACPI developments, any UEFI member
can join the group and contribute to ACPI specification.

So update the ownership and developers for ACPI in Kconfig accordingly,
and update the website link to ACPI specification too.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index c205653..831e541 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -32,9 +32,10 @@ menuconfig ACPI
 	  <http://acpica.org/>
 
 	  ACPI is an open industry specification co-developed by
-	  Hewlett-Packard, Intel, Microsoft, Phoenix, and Toshiba.
+	  ACPI Specification Working Group (ASWG) under UEFI Forum, any
+	  UEFI member can join ASWG and contribute to ACPI specification.
 	  The specification is available at:
-	  <http://www.acpi.info>
+	  <http://www.uefi.org/acpi/specs>
 
 if ACPI
 
-- 
1.7.9.5

