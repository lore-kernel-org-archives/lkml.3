Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaJXK65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:58:57 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36262 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaJXK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:58:56 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v12 06/15] arm: mv78xx0: Enable DEBUG_LL_UART_8250
Date: Fri, 24 Oct 2014 11:54:27 +0100
Message-Id: <1414148076-12685-7-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defconfig already enables DEBUG_LL and by default DEBUG_LL_UART_NONE
will be selected (but due to some back compatibility magic we eventually
need to remove it is not actually honoured). DEBUG_LL_UART_8250 is a much
saner default.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/configs/mv78xx0_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 0dae1c1..85d10d2 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -132,6 +132,7 @@ CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
-- 
1.9.3

