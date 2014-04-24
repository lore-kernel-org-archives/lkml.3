Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbaDXTEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:04:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43969 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758845AbaDXTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:04:26 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 2/5] clk: berlin: add berlin clocks DT bindings documentation
Date: Thu, 24 Apr 2014 21:04:09 +0200
Message-Id: <1398366252-19582-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the newly added berlin clock driver

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/devicetree/bindings/clock/berlin-clock.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
index 49b7860bffb8..49bc229827a0 100644
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
+	reg = <0xea023c 0x4>;
+};
-- 
1.9.1

