Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3KTHXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:23:46 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50625 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969Ab3KTHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:23:44 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, michael.opdenacker@free-electrons.com,
        Yanis Moreno <yanis.moreno63@gmail.com>
Subject: [PATCH] ARM: at91: remove redundant dependency
Date: Wed, 20 Nov 2013 08:23:10 +0100
Message-Id: <1384932191-8967-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanis Moreno <yanis.moreno63@gmail.com>

This removes the "depends on SOC_SAM_V7" statement
in a Kconfig section that's under an "if SOC_SAM_V7"
condition (same parameter).

Signed-off-by: Yanis Moreno <yanis.moreno63@gmail.com>
Reviewed-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

---
 arch/arm/mach-at91/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 699b71e..d1b3fe5 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -61,7 +61,6 @@ comment "Atmel AT91 Processor"
 if SOC_SAM_V7
 config SOC_SAMA5D3
 	bool "SAMA5D3 family"
-	depends on SOC_SAM_V7
 	select SOC_SAMA5
 	select HAVE_FB_ATMEL
 	select HAVE_AT91_DBGU1
-- 
1.7.9.5

