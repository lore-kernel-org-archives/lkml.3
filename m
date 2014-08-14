Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaHNAIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:08:23 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:42068 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaHNAIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:08:20 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>
Cc: stefan@agner.ch, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Addy Ke <addy.ke@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Add mmc0 and mmc1 aliases for rk3288
Date: Wed, 13 Aug 2014 17:08:00 -0700
Message-Id: <1407974880-30626-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's convenient (and less confusing to people reading logs) if the
eMMC port on rk3288 is consistenly marked with mmc0 and the sdmmc port
on rk3288 is consistently marked with mmc1.  Add the appropriate
aliases.

These aliases only actually do something if a patch like
(https://patchwork.kernel.org/patch/3925551/) lands, but they don't
hurt even before that patch.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Sonny Rao <sonnyrao@chromium.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..0b54b0d 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -29,6 +29,8 @@
 		i2c3 = &i2c3;
 		i2c4 = &i2c4;
 		i2c5 = &i2c5;
+		mmc0 = &emmc;
+		mmc1 = &sdmmc;
 		serial0 = &uart0;
 		serial1 = &uart1;
 		serial2 = &uart2;
-- 
2.1.0.rc2.206.gedb03e5

