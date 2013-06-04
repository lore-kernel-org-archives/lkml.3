Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab3FDFzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:55:51 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37275 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3FDFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:55:44 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH v2 2/2] staging: gdm72xx: fix typos in Kconfig
Date: Mon,  3 Jun 2013 22:55:39 -0700
Message-Id: <1370325339-19956-2-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370325339-19956-1-git-send-email-benchan@chromium.org>
References: <1370325339-19956-1-git-send-email-benchan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
 drivers/staging/gdm72xx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
index dd47bd1..dd8a391 100644
--- a/drivers/staging/gdm72xx/Kconfig
+++ b/drivers/staging/gdm72xx/Kconfig
@@ -19,7 +19,7 @@ config WIMAX_GDM72XX_K_MODE
 	default n
 
 config WIMAX_GDM72XX_WIMAX2
-	bool "Enable WIMAX2 support"
+	bool "Enable WiMAX2 support"
 	default n
 
 choice
@@ -38,7 +38,7 @@ endchoice
 if WIMAX_GDM72XX_USB
 
 config WIMAX_GDM72XX_USB_PM
-	bool "Enable power managerment support"
+	bool "Enable power management support"
 	depends on PM_RUNTIME
 
 endif # WIMAX_GDM72XX_USB
-- 
1.8.2.1

