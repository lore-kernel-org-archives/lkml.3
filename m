Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaF3LbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:31:23 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55727 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaF3LbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:31:21 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v7 1/4] ARM: versatile: Enable DEBUG_LL_UART_PL01X
Date: Mon, 30 Jun 2014 12:30:52 +0100
Message-Id: <1404127855-30459-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
References: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org>
 <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
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
index d52b4ff..ea49d37 100644
--- a/arch/arm/configs/versatile_defconfig
+++ b/arch/arm/configs/versatile_defconfig
@@ -82,5 +82,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_PL01X=y
 CONFIG_FONTS=y
 CONFIG_FONT_ACORN_8x8=y
-- 
1.9.3

