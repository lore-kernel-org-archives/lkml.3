Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbbAHBlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:41:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:37386 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbbAHBlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:01 -0500
X-AuditID: cbfee68f-f791c6d000004834-d3-54ade02a1f9f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic exynos
 memory bus frequency driver
Date: Thu, 08 Jan 2015 10:40:51 +0900
Message-id: <1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkUFfrwdoQg5drrCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXFs2yLWgpXaFV97lzM1MB5X6GLk4JAQMJG4/LW8i5ETyBST
	uHBvPVsXIxeHkMBSRomGRUtZIRImEis3b2GFSCxilHi7ZiMLhNPEJPFqxXxGkCo2AS2J/S9u
	sIHYIgJ6Ep3H9rCD2MwCf5gkmjaxgNjCAlkS0/8vAbNZBFQlbs1azwRi8wq4SFz93cUMsU1B
	YtnymWCbOQVcJfqfXgOzhYBqLj9exQiyWELgJbvE8TmvoQYJSHybfIgF4h1ZiU0HoOZIShxc
	cYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBEXX637P+HYx3D1gfYhTgYFTi
	4S3oWxMixJpYVlyZe4jRFGjDRGYp0eR8YNzmlcQbGpsZWZiamBobmVuaKYnzLpT6GSwkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qB0eCbmOk52YdzZ7SrZ5xjnsdoHly3T15jzbV3y83Tbol5
	rcjqN++XcbvIU55c27J7l+mp90/vzctJ3vH9o8ZeMQmXzs2cE1yaxB5rdWjrLvLYU/zdZcJ9
	9x+3DM+eiOcKjcx29VM8v3xulVPEL+OXN1cIm/b3P1t18rq/5oT9ixO5dt76vyFEQYmlOCPR
	UIu5qDgRAPQD4q6jAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2tB2tDDDb1G1o8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGsW2LWAtWald87V3O
	1MB4XKGLkZNDQsBEYuXmLawQtpjEhXvr2boYuTiEBBYxSrxds5EFwmlikni1Yj4jSBWbgJbE
	/hc32EBsEQE9ic5je9hBbGaBP0wSTZtYQGxhgSyJ6f+XgNksAqoSt2atZwKxeQVcJK7+7mKG
	2KYgsWz5TLDNnAKuEv1Pr4HZQkA1lx+vYpzAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5y
	fu4mRnDEPpPewbiqweIQowAHoxIPb0HfmhAh1sSy4srcQ4wSHMxKIrxdZ9eGCPGmJFZWpRbl
	xxeV5qQWH2I0BbpqIrOUaHI+MJnklcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphak
	FsH0MXFwSjUwcmaZvrv964gYw+5nTTOdd3j/vPjv+9GVyik8fiH/osqLNXvbTjpNXDnnf/Ij
	zifeMtdk7WTqL54ITUgz9CpIufTz8bkehfnFz+WFDlVJsYWLzvql+P1KA1+706a1DLUCb/ha
	y4UeHrjUpie1o3ze25+MPM+ufu7/HnFrUeE+063yDceP7Jw0QYmlOCPRUIu5qDgRAMOBpoXu	AgAA
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
Cc: Kukjin Kim <kgene@kernel.org>
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

