Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaLaFWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:22:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaLaFUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:20:00 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ea-54a3877aa982
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
Date: Wed, 31 Dec 2014 14:19:46 +0900
Message-id: <1420003192-5576-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSqFvVvjjEYM89DYvHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAldGb/MMxoI27Yr//9sZGxhXKnQxcnJICJhILJ61nxnCFpO4cG89WxcjF4eQwFJG
	iW/vLjHBFG1ftI0VIrGIUeLw/qNQVU1MElNuTWUBqWIT0JLY/+IGG4gtIiAjcXXjdhaQImaB
	/0wSj18tZwVJCAvkScz41w42lkVAVaLj53Qwm1fARWL37I3sEOsUJJYtnwlUz8HBKeAqMeGL
	M0hYCKhkxpZmJpCZEgK32CUWtt9ngZgjIPFt8iEWkHoJAVmJTQeg3pGUOLjiBssERuEFjAyr
	GEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj5/S/Z307GG8esD7EKMDBqMTDe8NucYgQa2JZ
	cWXuIUZToA0TmaVEk/OBUZpXEm9obGZkYWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVAOjReJ2y8TnUfc1ROTfqD+pu6TKmFj7fzLrkcKjwvwVwZwsZ4TX79c+Oe/Z
	9wjtLzObL7zZs8JZ5EK93DbtibPXzpvO2N1Vc+rGiYM1n+56FAmwVk/RXPxjT1iXvKZUQ/2C
	krUTZCx/HHkSd+X99uqJ37tjZml/+Hj3zdar5SeXszQL7Wovj2pLU2Ipzkg01GIuKk4EADnN
	ifmaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd2q9sUhBu9bFSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM3qbZzAWtGlX/P/fztjAuFKhi5GTQ0LA
	RGL7om2sELaYxIV769m6GLk4hAQWMUoc3n8UymlikphyayoLSBWbgJbE/hc32EBsEQEZiasb
	t7OAFDEL/GeSePxqOdgoYYE8iRn/2plAbBYBVYmOn9PBbF4BF4ndszeyQ6xTkFi2fCZQPQcH
	p4CrxIQvziBhIaCSGVuamSYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERydz6R2
	MK5ssDjEKMDBqMTDe8NucYgQa2JZcWXuIUYJDmYlEd7LmkAh3pTEyqrUovz4otKc1OJDjKZA
	R01klhJNzgcmjrySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6pBsad
	0Tx5szbF/uBmFnPK3Xump+NXnftmx7qEXJNdW3LrTANt/n4M+vrvcljL8xK2Dc9r1OQL9oVL
	7Jk/LXOK1usrpU8WuR2pmsV29dTn8/Lad/5qL3zta/a5IP1KfZ/T+dcPNNTu3rr5S1mc+c5F
	0cLzV95WyJ8PuvquMbGnZZnzgc2mnuJ351oosRRnJBpqMRcVJwIAMnZNXeQCAAA=
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

