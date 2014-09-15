Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaIOWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:09:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37965 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaIOWJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:09:55 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH] arm: Remove redundant config value DEBUG_UART_NETX
Date: Mon, 15 Sep 2014 23:09:46 +0100
Message-Id: <1410818986-13273-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 880fa9b6fd73 ("ARM: 8144/1: netx: Migrate DEBUG_LL macros to
shared directory") spuriously introduces an unused config variable,
DEBUG_UART_NETX. Let's remove it.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/Kconfig.debug | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 537dd04..b6ec25a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -450,7 +450,6 @@ choice
 	config DEBUG_NETX_UART
 		bool "Kernel low-level debugging messages via NetX UART"
 		depends on ARCH_NETX
-		select DEBUG_UART_NETX
 		help
 		  Say Y here if you want kernel low-level debugging support
 		  on Hilscher NetX based platforms.
-- 
1.9.3

