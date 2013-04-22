Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3DVKEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:04:55 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44551 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3DVKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:04:52 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: cfa10036: dt: Change i2c0 clock frequency
Date: Mon, 22 Apr 2013 12:02:22 +0200
Message-Id: <1366624945-5708-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366624945-5708-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1366624945-5708-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OLED display can work faster. Change the i2c controller clock
frequency to remove the tearing effect that can be seen on the display.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10036.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
index 40488f5a8..a524caf 100644
--- a/arch/arm/boot/dts/imx28-cfa10036.dts
+++ b/arch/arm/boot/dts/imx28-cfa10036.dts
@@ -67,6 +67,7 @@
 			i2c0: i2c@80058000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&i2c0_pins_b>;
+				clock-frequency = <400000>;
 				status = "okay";
 
 				ssd1306: oled@3c {
-- 
1.7.10.4

