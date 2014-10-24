Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaJXBZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:25:04 -0400
Received: from exprod5og122.obsmtp.com ([64.18.0.192]:45973 "HELO
	exprod5og122.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754163AbaJXBYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:24:30 -0400
From: Feng Kan <fkan@apm.com>
To: catalin.marinas@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: [PATCH 7/7] arm64: dts: Add PMU node for APM X-Gene Storm SOC
Date: Thu, 23 Oct 2014 18:24:22 -0700
Message-Id: <1414113862-15067-8-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414113862-15067-1-git-send-email-fkan@apm.com>
References: <1414113862-15067-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PMU device tree node for APM X-Gene Storm SOC.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index b2e6068..85d2dd7 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -97,6 +97,11 @@
 		clock-frequency = <50000000>;
 	};
 
+	pmu {
+		compatible = "apm,potenza-pmu", "arm,armv8-pmuv3";
+		interrupts = <1 12 0xff04>;
+	};
+
 	soc {
 		compatible = "simple-bus";
 		#address-cells = <2>;
-- 
1.9.1

