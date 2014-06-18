Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFROyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:54:50 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49896 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaFROxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:53:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: [PATCH 4/7] ARM: stih416-b2020e: Enable PWM on the B2020 Rev-E
Date: Wed, 18 Jun 2014 15:52:49 +0100
Message-Id: <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the infrastructure is now in place for ST's PWM controller.  This
patch takes the final step and enables the IP on the 2020 Rev-E
development platform.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020e.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2020e.dts b/arch/arm/boot/dts/stih416-b2020e.dts
index ba0fa2c..07cbf5b 100644
--- a/arch/arm/boot/dts/stih416-b2020e.dts
+++ b/arch/arm/boot/dts/stih416-b2020e.dts
@@ -31,5 +31,15 @@
 		ethernet1: dwmac@fef08000 {
 			snps,reset-gpio = <&PIO0 7>;
 		};
+
+		/* SAS PWM Module */
+		pwm0: pwm@fed10000 {
+			status		= "okay";
+		};
+
+		/* SBC PWM Module */
+		pwm1: pwm@fe510000 {
+			status		= "okay";
+		};
 	};
 };
-- 
1.8.3.2

