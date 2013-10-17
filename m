Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925Ab3JQVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:32:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32789 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762810Ab3JQVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:31:32 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH 2/3] ARM: dts: MSM8974: Add restart node
Date: Thu, 17 Oct 2013 14:31:28 -0700
Message-Id: <1382045489-21075-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.516.g1d25dd4
In-Reply-To: <1382045489-21075-1-git-send-email-sboyd@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
 <1382045489-21075-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the restart node so we can reboot the device.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 2ebb4f0..5ac7701 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -30,4 +30,9 @@
 			clock-frequency = <19200000>;
 		};
 	};
+
+	restart@fc4ab000 {
+		compatible = "qcom,pshold";
+		reg = <0xfc4ab000 0x4>;
+	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

