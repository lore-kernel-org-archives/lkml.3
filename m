Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaHSPRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:17:13 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34912 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaHSPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:17:06 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v9 2/9] arm: ep93xx: Enable DEBUG_LL_UART_PL01X
Date: Tue, 19 Aug 2014 16:16:40 +0100
Message-Id: <1408461407-10429-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
References: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
 <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defconfig already enables DEBUG_LL and by default DEBUG_LL_UART_NONE
will be selected (but due to some back compability magic I'd like to
remove is not actually honoured). DEBUG_LL_UART_PL01X is a much saner
default.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/configs/ep93xx_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 1b650c8..72233b9 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -107,5 +107,6 @@ CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_PL01X=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_LIBCRC32C=y
-- 
1.9.3

