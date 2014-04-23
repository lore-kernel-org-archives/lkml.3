Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaDWOBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:01:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57898 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084AbaDWOBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:01:34 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 2/5] clk: berlin: add berlin clocks DT bindings documentation
Date: Wed, 23 Apr 2014 16:01:04 +0200
Message-Id: <1398261667-12621-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the newly added berlin clock driver

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Cc: devicetree@vger.kernel.org
 Documentation/devicetree/bindings/clock/berlin-clock.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
index 49b7860bffb8..00f0053ef587 100644
--- a/Documentation/devicetree/bindings/clock/berlin-clock.txt
+++ b/Documentation/devicetree/bindings/clock/berlin-clock.txt
@@ -9,6 +9,8 @@ Required properties:
 	"marvell,berlin2-pll",
 	"marvell,berlin2q-pll":
 		CPU PLL and System PLL
+	"marvell,berlin2-clk":
+		simple clocks
 - reg: Address and length of the clock register set.
 - #clock-cells: from common clock binding; shall be set to 0.
 - clocks: from common clock binding
@@ -26,4 +28,9 @@ cpupll: cpupll@ea003c {
 	reg = <0xea003c 0x8>;
 };
 
-
+sdio0xinclk: sdio0xinclk@ea023c {
+	compatible = "marvell,berlin-clk";
+	clocks = <&syspll>;
+	#clock-cells = <0>;
+	reg = <0xea023c 4>;
+};
-- 
1.9.1

