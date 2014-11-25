Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaKYJiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:38:05 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58496 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaKYJiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:38:01 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: rockchip: change the max voltage of cpu to 1.4v
Date: Tue, 25 Nov 2014 17:37:32 +0800
Message-Id: <1416908253-31721-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
References: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the cpu frequencies up to 1.8Ghz, we need set the vdd_cpu to 1.4v.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

 arch/arm/boot/dts/rk3288-evb-rk808.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index d8c775e6..d4f74dd 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -48,7 +48,7 @@
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <750000>;
-				regulator-max-microvolt = <1350000>;
+				regulator-max-microvolt = <1400000>;
 				regulator-name = "vdd_arm";
 			};
 
-- 
1.9.1

