Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaKYJiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:38:13 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64096 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaKYJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:38:09 -0500
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
Subject: [PATCH 2/2] ARM: dts: rk3288: change the max clk of cpu to 1.8Ghz
Date: Tue, 25 Nov 2014 17:37:33 +0800
Message-Id: <1416908253-31721-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
References: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum cpu frequency of rk3288 can up to 1.8Ghz,
and it need to set the vdd_cpu to 1.4v correspondingly.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

 arch/arm/boot/dts/rk3288.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 0f50d5d..4f77a05 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -56,8 +56,10 @@
 			resets = <&cru SRST_CORE0>;
 			operating-points = <
 				/* KHz    uV */
-				1608000 1350000
-				1512000 1300000
+				1800000 1400000
+				1704000 1350000
+				1608000 1300000
+				1512000 1250000
 				1416000 1200000
 				1200000 1100000
 				1008000 1050000
-- 
1.9.1

