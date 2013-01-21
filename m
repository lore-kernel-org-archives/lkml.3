Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3AUNfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:35:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55714 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab3AUNfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:35:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Turn on the 'heartbeat' LED trigger
Date: Mon, 21 Jan 2013 13:35:40 +0000
Message-Id: <1358775340-8197-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The heartbeat LED trigger provides an excellent debugging tool
when hacking on development boards. Here we enable it on all
u8500 based platforms. This will pulse the User LED on the
Snowball low-cost development board only.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 029961d..16368ef 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -91,6 +91,8 @@ CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_LM3530=y
 CONFIG_LEDS_LP5521=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AB8500=y
 CONFIG_RTC_DRV_PL031=y
-- 
1.7.9.5

