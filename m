Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaJRV07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 17:26:59 -0400
Received: from alderaan.wessner.org ([213.136.64.202]:42185 "EHLO wessner.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaJRV06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 17:26:58 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2014 17:26:57 EDT
From: Joseph Wessner <joseph@wessner.org>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joseph Wessner <joseph@wessner.org>
Subject: [PATCH] Arch: ia64: kernel: acpi: fixed a brace coding style issue.
Date: Sat, 18 Oct 2014 23:21:10 +0200
Message-Id: <1413667270-28890-1-git-send-email-joseph@wessner.org>
X-Mailer: git-send-email 2.1.2
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (wessner.org [0.0.0.0]); Sat, 18 Oct 2014 23:21:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Joseph Wessner <joseph@wessner.org>
---
 arch/ia64/kernel/acpi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 615ef81..12c032e 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -273,9 +273,8 @@ acpi_parse_plat_int_src(struct acpi_subtable_header * header,
 						IOSAPIC_EDGE : IOSAPIC_LEVEL);
 
 	platform_intr_list[plintsrc->type] = vector;
-	if (acpi_madt_rev > 1) {
+	if (acpi_madt_rev > 1)
 		acpi_cpei_override = plintsrc->flags & ACPI_MADT_CPEI_OVERRIDE;
-	}
 
 	/*
 	 * Save the physical id, so we can check when its being removed
-- 
2.1.2

