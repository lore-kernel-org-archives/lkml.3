Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3JCUOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:14:05 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3236 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab3JCUNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:13:54 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, patches@linaro.org
Subject: [PATCH 1/6] ARM: dts: Declare clocks as fixed on bcm11351
Date: Thu, 3 Oct 2013 13:13:09 -0700
Message-ID: <1380831194-27238-2-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1380831194-27238-1-git-send-email-tim.kryger@linaro.org>
References: <1380831194-27238-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E5310730UO13716385-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare clocks that are enabled and configured by bootloaders as fixed
rate clocks in the DTS such that device drivers may use standard clock
function calls.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 97 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 98e6bc0..c348b09 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -126,4 +126,101 @@
 		status = "disabled";
 	};
 
+	clocks {
+		bsc1_clk: bsc1 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		bsc2_clk: bsc2 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		bsc3_clk: bsc3 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		bsc4_clk: bsc4 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		hub_timer_clk: hub_timer {
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+			#clock-cells = <0>;
+		};
+
+		pwm_clk: pwm {
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio1_clk: sdio1 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio2_clk: sdio2 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio3_clk: sdio3 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio4_clk: sdio4 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		tmon_1m_clk: tmon_1m {
+			compatible = "fixed-clock";
+			clock-frequency = <1000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb_clk: uartb {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb2_clk: uartb2 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb3_clk: uartb3 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb4_clk: uartb4 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		usb_otg_ahb_clk: usb_otg_ahb {
+			compatible = "fixed-clock";
+			clock-frequency = <52000000>;
+			#clock-cells = <0>;
+		};
+	};
 };
-- 
1.8.0.1


