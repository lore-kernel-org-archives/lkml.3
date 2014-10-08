Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaJHJez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:34:55 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59842 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbaJHJdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:33:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux@roeck-us.net
Subject: [PATCH 2/4] ARM: multi_v7_defconfig: Enable support for ST's LPC Watchdog
Date: Wed,  8 Oct 2014 10:33:28 +0100
Message-Id: <1412760810-23199-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
References: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5fb95fb..034aeab 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -238,6 +238,7 @@ CONFIG_ST_THERMAL_SYSCFG=y
 CONFIG_ST_THERMAL_MEMMAP=y
 CONFIG_WATCHDOG=y
 CONFIG_ORION_WATCHDOG=y
+CONFIG_ST_WATCHDOG=y
 CONFIG_SUNXI_WATCHDOG=y
 CONFIG_MFD_AS3722=y
 CONFIG_MFD_BCM590XX=y
-- 
1.9.1

