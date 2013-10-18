Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3JRR4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:56:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54326 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3JRR4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:56:51 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH v2 2/4] ARM: dts: MSM8974: Add restart node
Date: Fri, 18 Oct 2013 10:56:44 -0700
Message-Id: <1382119006-22231-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.544.g2141c47
In-Reply-To: <1382119006-22231-1-git-send-email-sboyd@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
 <1382119006-22231-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the restart node so we can reboot the device.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 2ebb4f0..df18637 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -29,5 +29,10 @@
 				     <1 1 0xf08>;
 			clock-frequency = <19200000>;
 		};
+
+		restart@fc4ab000 {
+			compatible = "qcom,pshold";
+			reg = <0xfc4ab000 0x4>;
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

