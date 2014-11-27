Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaK0Hf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:35:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaK0HfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:21 -0500
X-AuditID: cbfee691-f79b86d000004a5a-f8-5476d43639e5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, cw00.choi@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/19] clk: samsung: Add binding documentation for Exynos5433
 clock controller
Date: Thu, 27 Nov 2014 16:34:59 +0900
Message-id: <1417073716-22997-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkRNfsSlmIwZfZ1haP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbeY8mc5k8Wm
	x9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzeLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6MJwuWshdsV654f2QJSwPjctkuRk4OCQETiXeHtzNB2GISF+6tZ+ti5OIQEljKKHHwUzcT
	TFHL+gusEInpjBL/fnUzQjhNTBK3Vj5gB6liE9CS2P/iBhuILSLgLNEwtZEJpIhZ4COzRMO0
	i6wgCWGBBIkVnY8YQWwWAVWJ1e0LwVbwCrhKPJ/wmA1inYLEsuUzweo5Bdwk9n89CGYLAdUs
	+nYFbKiEwFwOie0tzcwQgwQkvk0+xNLFyAGUkJXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBc
	UJyUXmSqV5yYW1yal66XnJ+7iREYm6f/PZu4g/H+AetDjAIcjEo8vBYHykKEWBPLiitzDzGa
	Am2YyCwlmpwPTAB5JfGGxmZGFqYmpsZG5pZmSuK8OtI/g4UE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUwTrbOYqr3awieHbhC3uDila2JDiVHXP6+nS3+aqFGlc2rnY+ZFwmd7rhkun/KJXOe
	D5ffnl5yON7tUv8Sy6vbU622i5bdKvVtvjP5FWvjhXUt5kLh+7aE2Hu9ZOtfVHTFW37W9/2R
	woeclW6WVj5getY3Xe+382HD+xFNsaW/JnfszTuopy2apMRSnJFoqMVcVJwIAIXg/n3IAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQV2zK2UhBjffGVg8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjxZsJS9YLtyxfsjS1gaGJfLdjFyckgImEi0rL/A
	CmGLSVy4t56ti5GLQ0hgOqPEv1/djBBOE5PErZUP2EGq2AS0JPa/uMEGYosIOEs0TG1kAili
	FvjILNEw7SLYKGGBBIkVnY8YQWwWAVWJ1e0LmUBsXgFXiecTHrNBrFOQWLZ8Jlg9p4CbxP6v
	B8FsIaCaRd+uME1g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjyn0nvYFzVYHGI
	UYCDUYmH1+JAWYgQa2JZcWXuIUYJDmYlEV6pRUAh3pTEyqrUovz4otKc1OJDjKZAV01klhJN
	zgcmpbySeENjEzMjSyNzQwsjY3Mlcd4bN3NDhATSE0tSs1NTC1KLYPqYODilGhj7eTZ61x3b
	llS8YG3Fu3cf9A/tXjR9/8l3AY4/Ug64lG/eXvpn0rK3D39VHpi9X763veKXyudA+Ul7e3Jm
	G8Q9etPM2t3mKDJrm6nlipWnp8yYfL0gLms1p532pl0FJxZGfZrB8vdjK+uztY+dnz5g1FTU
	WrFFb/bZXDFNS+/ZmvfjunYxrd3xQ4mlOCPRUIu5qDgRAABrB8gSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add binding documentation for Exynos5433 clock controller.
Exynos5433 has various clock domains So, this documentation explains
the detailed clock domains ans usage guide.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 .../devicetree/bindings/clock/exynos5433-clock.txt | 106 +++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/exynos5433-clock.txt b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
new file mode 100644
index 0000000..72cd0ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos5433-clock.txt
@@ -0,0 +1,106 @@
+* Samsung Exynos5433 CMU (Clock Management Units)
+
+The Exynos5433 clock controller generates and supplies clock to various
+controllers within the Exynos5433 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,exynos5433-cmu-top"   - clock controller compatible for CMU_TOP
+    which generates clocks for IMEM/FSYS/G3D/GSCL/HEVC/MSCL/G2D/MFC/PERIC/PERIS
+    domains and bus clocks.
+  - "samsung,exynos5433-cmu-cpif"  - clock controller compatible for CMU_CPIF
+    which generates clocks for LLI (Low Latency Interface) IP.
+  - "samsung,exynos5433-cmu-mif"   - clock controller compatible for CMU_MIF
+    which generates clocks for DRAM Memory Controller domain.
+  - "samsung,exynos5433-cmu-peric" - clock controller compatible for CMU_PERIC
+    which generates clocks for UART/I2C/SPI/I2S/PCM/SPDIF/PWM/SLIMBUS IPs.
+  - "samsung,exynos5433-cmu-peris" - clock controller compatible for CMU_PERIS
+    which generates clocks for PMU/TMU/MCT/WDT/RTC/SECKEY/TZPC IPs.
+  - "samsung,exynos5433-cmu-fsys"  - clock controller compatible for CMU_FSYS
+    which generates clocks for USB/UFS/SDMMC/TSI/PDMA IPs.
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/exynos5433.h header and can be used in device
+tree sources.
+
+Example 1: Examples of clock controller nodes are listed below.
+
+	cmu_top: clock-controller@0x10030000 {
+		compatible = "samsung,exynos5433-cmu-top";
+		reg = <0x10030000 0x0c04>;
+		#clock-cells = <1>;
+	};
+
+	cmu_cpif: clock-controller@0x10fc0000 {
+		compatible = "samsung,exynos5433-cmu-cpif";
+		reg = <0x10fc0000 0x0c04>;
+		#clock-cells = <1>;
+	};
+
+	cmu_mif: clock-controller@0x105b0000 {
+		compatible = "samsung,exynos5433-cmu-mif";
+		reg = <0x105b0000 0x100c>;
+		#clock-cells = <1>;
+	};
+
+	cmu_peric: clock-controller@0x14c80000 {
+		compatible = "samsung,exynos5433-cmu-peric";
+		reg = <0x14c80000 0x0b08>;
+		#clock-cells = <1>;
+	};
+
+	cmu_peris: clock-controller@0x10040000 {
+		compatible = "samsung,exynos5433-cmu-peris";
+		reg = <0x10040000 0x0b20>;
+		#clock-cells = <1>;
+	};
+
+	cmu_fsys: clock-controller@0x156e0000 {
+		compatible = "samsung,exynos5433-cmu-fsys";
+		reg = <0x156e0000 0x0b04>;
+		#clock-cells = <1>;
+	};
+
+Example 2: UART controller node that consumes the clock generated by the clock
+	   controller.
+
+	serial_0: serial@14C10000 {
+		compatible = "samsung,exynos5433-uart";
+		reg = <0x14C10000 0x100>;
+		interrupts = <0 421 0>;
+		clocks = <&cmu_peric CLK_PCLK_UART0>,
+			 <&cmu_peric CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart0_bus>;
+		status = "disabled";
+	};
+
+Example 3: SPI controller node that consumes the clock generated by the clock
+	   controller.
+
+	spi_0: spi@14d20000 {
+		compatible = "samsung,exynos7-spi";
+		reg = <0x14d20000 0x100>;
+		interrupts = <0 432 0>;
+		dmas = <&pdma0 9>, <&pdma0 8>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&cmu_peric CLK_PCLK_SPI0>,
+			 <&cmu_top CLK_SCLK_SPI0_PERIC>;
+		clock-names = "spi", "spi_busclk0";
+		samsung,spi-src-clk = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_bus>;
+		status = "disabled";
+	};
-- 
1.8.5.5

