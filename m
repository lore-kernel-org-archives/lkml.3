Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaLWLqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:46:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56422 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbaLWLon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:44:43 -0500
X-AuditID: cbfee68f-f791c6d000004834-e9-549955a6bd0f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCH 2/4] devfreq: exynos: Add documentation for generic exynos
 memory bus frequency driver
Date: Tue, 23 Dec 2014 20:44:35 +0900
Message-id: <1419335077-31020-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
References: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrLssdGaIwdw7chaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6M3uYZjAVt2hX//7czNjCuVOhi5OSQEDCRuPHkBzOELSZx4d56ti5GLg4hgaWM
	Ej//fGKCKer52MECkZjOKLHg8XuoqiYmiUk3L4JVsQloSex/cYMNxBYRkJG4unE7WAezQCOz
	xJdl/8GKhAVyJJ62HWcFsVkEVCV6tk0F280r4CrxcGMb1B0KEsuWzwSr4RRwk/j34x0LiC0E
	VHPm1w2omlvsEo+3VkPMEZD4NvkQUA0HUFxWYtMBqBJJiYMrbrBMYBRewMiwilE0tSC5oDgp
	vchYrzgxt7g0L10vOT93EyMwfk7/e9a/g/HuAetDjAIcjEo8vAvOzAgRYk0sK67MPcRoCrRh
	IrOUaHI+MErzSuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAmDr9eJJmgvzmSu95ESU9/IKRyyWf9PXuFXl4ZWbi3EbrKRHVdiZvO0JCbse8fZahf3On
	drv57Nh7s86d8k+uYX5Ykez8/2HiRfYjhe68dupnuAtY9sf33L+kffP3EZ30/bU17yKY0865
	5q3kLxc/IaZyl1W486RP0JUJDh0TZl582Nn293qOEktxRqKhFnNRcSIAywrNMZoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd1loTNDDM4dELV4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzOhtnsFY0KZd8f9/O2MD40qFLkZODgkB
	E4mejx0sELaYxIV769m6GLk4hASmM0osePweymlikph08yITSBWbgJbE/hc32EBsEQEZiasb
	t7OAFDELNDJLfFn2H6xIWCBH4mnbcVYQm0VAVaJn21RmEJtXwFXi4cY2Zoh1ChLLls8Eq+EU
	cJP49+Md2BlCQDVnft1gnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcHw+k9rB
	uLLB4hCjAAejEg/vgjMzQoRYE8uKK3MPMUpwMCuJ8CoHzgwR4k1JrKxKLcqPLyrNSS0+xGgK
	dNVEZinR5Hxg6sgriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamCc
	rpm5JOhXzjrD2yFPei1W9oa0J6ju2eCcfu1MXPREu5a27csf/DZ/f5WXben3si9chhK32eXk
	H1160vPozJQ5ldq37CS5Cnd9KPoh5mB2/dzfe2at0heN3B7NTrUxuMcgdLQjxyW43vX8yoNH
	OhQ11vOdrTv5ITKaKVNyc8p9ieKANSbSeXJKLMUZiYZazEXFiQAsViAe5QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for generic exynos memory bus frequency
driver.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../devicetree/bindings/devfreq/exynos-busfreq.txt | 184 +++++++++++++++++++++
 1 file changed, 184 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt

diff --git a/Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt b/Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
new file mode 100644
index 0000000..c601e88
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
@@ -0,0 +1,184 @@
+
+* Generic Exynos Memory Bus device
+
+The Samsung Exynos SoCs have many memory buses for data transfer between DRAM
+memory and MMC/sub-IP in SoC. Almost Exynos SoCs have the common architecture
+for memory buses. Generally, Exynos SoC express the memory bus by using memory
+bus group and block. The memory bus group has one more memory bus blocks and
+OPP table (including frequency and voltage for DVFS), regulator, devfreq-event
+devices. Each memory bus block has a clock for own memory bus speen and
+frequency table for DVFS. There are a little different among Exynos SoCs
+because each Exynos SoC has the different sub-IP and differnt memory bus.
+So, this difference should be specified in devicetree file.
+
+Required properties for memory bus group:
+- compatible: Should be "samsung,exynos-memory-bus".
+- operating-points: the OPP table including frequency/voltage information to
+                  support DVFS (Dynamic Voltage/Frequency Scaling) feature.
+- devfreq-events: the devfreq-event device to monitor the curret state of
+                  memory bus group.
+- vdd-mem-supply: the regulator to provide memory bus group with the voltage.
+
+Required properties for memory bus block:
+- clock-names : the name of clock used by the memory bus, "memory-bus".
+- clocks : phandles for clock specified in "clock-names" property.
+- #clock-cells: should be 1.
+- frequency: the frequency table to support DVFS feature.
+
+Example1 : Memory bus group/block in exynos3250.dtsi are listed below.
+	Exynos3250 has two memory bus group (MIF, INT group). MIF memory bus
+	group includes one memory bus block between DRAM and eMMC. Also, INT
+	memory bus group includes eight memory bus blocks which support each
+	sub-IPs between DRAM and sub-IPs.
+
+	memory_bus_mif: memory_bus@0 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			400000 875000
+			200000 800000
+			133000 800000
+			100000 800000
+			50000  800000>;
+		status = "disabled";
+
+		blocks {
+			dmc_block: memory_bus_block1 {
+				clocks = <&cmu_dmc CLK_DIV_DMC>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					200000
+					133000
+					100000
+					50000>;
+			};
+		};
+	};
+
+	memory_bus_int: memory_bus@1 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			400000 950000
+			200000 950000
+			133000 925000
+			100000 850000
+			80000  850000
+			50000  850000>;
+
+		status = "disabled";
+
+		blocks {
+			peri_block: memory_bus_block1 {
+				clocks = <&cmu CLK_DIV_ACLK_100>;
+				clock-names = "memory-bus";
+				frequency = <
+					100000
+					100000
+					100000
+					100000
+					50000
+					50000>;
+			};
+
+			display_block: memory_bus_block2 {
+				clocks = <&cmu CLK_DIV_ACLK_160>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					100000
+					80000
+					80000
+					50000>;
+			};
+
+			isp_block: memory_bus_block3 {
+				clocks = <&cmu CLK_DIV_ACLK_200>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					100000
+					80000
+					50000
+					50000>;
+			};
+
+			gps_block: memory_bus_block4 {
+				clocks = <&cmu CLK_DIV_ACLK_266>;
+				clock-names = "memory-bus";
+				frequency = <
+					300000
+					200000
+					133000
+					100000
+					50000
+					50000>;
+			};
+
+			mcuisp_block: memory_bus_block5 {
+				clocks = <&cmu CLK_DIV_ACLK_400_MCUISP>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					200000
+					50000
+					50000
+					50000
+					50000>;
+			};
+
+			leftbus_block: memory_bus_block6 {
+				clocks = <&cmu CLK_DIV_GDL>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					133000
+					100000
+					100000
+					100000>;
+			};
+
+			rightbus_block: memory_bus_block7 {
+				clocks = <&cmu CLK_DIV_GDR>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					133000
+					100000
+					100000
+					100000>;
+			};
+
+			mfc_block: memory_bus_block8 {
+				clocks = <&cmu CLK_SCLK_MFC>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					200000
+					200000
+					133000
+					100000
+					80000>;
+			};
+		};
+	};
+
+Example2 : Usage case to handle the frequency/voltage of memory bus on runtime
+	in exynos3250-rinato.dts are listed below.
+
+	&memory_bus_mif {
+		devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+		vdd-mem-supply = <&buck1_reg>;
+		status = "okay";
+	};
+
+	&memory_bus_int {
+		devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+		vdd-mem-supply = <&buck3_reg>;
+		status = "okay";
+	};
-- 
1.8.5.5

