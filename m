Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbaJXK4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:56:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43708 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbaJXKz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:55:26 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v12 03/15] arm: iop33x: Enable DEBUG_LL_UART_8250
Date: Fri, 24 Oct 2014 11:54:24 +0100
Message-Id: <1414148076-12685-4-git-send-email-daniel.thompson@linaro.org>
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
 arch/arm/configs/iop33x_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index aa36128..713faee 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -87,5 +87,6 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRC32 is not set
-- 
1.9.3

