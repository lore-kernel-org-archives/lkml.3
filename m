Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaDGPy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:54:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42806 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbaDGPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:54:43 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v4 1/5] ARM: versatile: Enable DEBUG_LL_UART_PL01X
Date: Mon,  7 Apr 2014 16:54:12 +0100
Message-Id: <1396886056-18132-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396886056-18132-1-git-send-email-daniel.thompson@linaro.org>
References: <1396626102-13991-1-git-send-email-daniel.thompson@linaro.org>
 <1396886056-18132-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defconfig already enables DEBUG_LL and by default DEBUG_LL_UART_NONE
will be selected (but due to some back compability magic I'd like to
remove is not actually honoured). DEBUG_LL_UART_PL01X is a much saner
default.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/configs/versatile_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/versatile_defconfig b/arch/arm/configs/versatile_defconfig
index 073541a..5a51397 100644
--- a/arch/arm/configs/versatile_defconfig
+++ b/arch/arm/configs/versatile_defconfig
@@ -79,5 +79,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_PL01X=y
 CONFIG_FONTS=y
 CONFIG_FONT_ACORN_8x8=y
-- 
1.9.0

