Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbbAHBlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:41:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11252 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbAHBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:03 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-29-54ade02bab16
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Youngjun Cho <yj44.cho@samsung.com>
Subject: [PATCHv3 7/8] ARM: dts: Add memory bus node for Exynos3250-based
 Rinato/Monk board
Date: Thu, 08 Jan 2015 10:40:56 +0900
Message-id: <1420681257-3078-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWyRsSkRFf7wdoQg6tTNSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YbTYu3Myo4Ogx5p5axg9ds66y+6xeM9LJo9NqzrZPDYvqffo
	27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujO9t21kL7vFV7F9/m62BcT9PFyMnh4SAicS+1aeZ
	IWwxiQv31rOB2EICSxklmv8XdTFygNX0vtXsYuQCCi9ilHj56xMrhNPEJLHz7x1WkAY2AS2J
	/S9ugDWLCOhJdB7bww5SxCywkFni1rYusISwQKzEzu4lYA0sAqoSX4/0M4LYvAIuEmd3LWCF
	uEJBYtnymWA2p4CrRP/Ta6wQF7lIXH68ihFkqITAV3aJlx+usUAMEpD4NvkQC8SpshKbDkB9
	IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBMbW6X/PJuxgvHfA+hCj
	AAejEg9vQd+aECHWxLLiytxDjKZAGyYyS4km5wMjOK8k3tDYzMjC1MTU2Mjc0kxJnPe11M9g
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxhPULuu1+WPFp71CVhtrTGtg7baQ/M73hK+P+M
	viVhwKp8+WnbuWWWl50svPv+e1yuL7mdEr7fROPbUm2L8HtXT/WKXlxns++pSpVkF7dF/D3H
	a08+Fq+fcEFiYta3LFclyduhFwS3fVpWscGtP7aFSfXu7pLVq5ao8i78r/TeUZ2xUcbB9L0S
	S3FGoqEWc1FxIgCrVH3yqAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAV3tB2tDDBYdkrd4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9Fi787JjA6CHmvmrWH02DnrLrvH4j0vmTw2repk89i8pN6j
	b8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgD5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZ8b9vOWnCP
	r2L/+ttsDYz7eboYOTgkBEwket9qdjFyApliEhfurWfrYuTiEBJYxCjx8tcnVginiUli5987
	rCBVbAJaEvtf3GADsUUE9CQ6j+1hByliFljILHFrWxdYQlggVmJn9xKwBhYBVYmvR/oZQWxe
	AReJs7sWsEKsU5BYtnwmmM0p4CrR//QamC0EVHP58SrGCYy8CxgZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEx+4z6R2MqxosDjEKcDAq8fAW9K0JEWJNLCuuzD3EKMHBrCTC23V2bYgQ
	b0piZVVqUX58UWlOavEhRlOgqyYyS4km5wPTSl5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6
	YklqdmpqQWoRTB8TB6dUA2PBHT+hP4kl16oYxaoPyJos+qS9VUOea/lPb4WVAYkHY2yn7793
	J4rT4fhHn9bnz49bcjOdfvnt1JJw6yNFj+I+RVxe9ZLtWifb7pWLvU/1LbXol9jF/IdPb27M
	b9sje19UTtjFsn93c/CB27f43753nsstH+d5pCPyqSxT/B7t1xa/tn75FLBciaU4I9FQi7mo
	OBEAyWSNPPMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Exynos3250 memory-bus node which includes the regulator
and devfreq-event phandle. The devfreq-event phandle is used for the
governor of devfreq device and provide the current usage state of
MIF (Memory Interface) / INT (Internal) memory bus group.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Youngjun Cho <yj44.cho@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 12 ++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index fcceb59..efadb16 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -460,6 +460,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 9dd1ce1..cf800ed 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -635,6 +635,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

