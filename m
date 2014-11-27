Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaK0HhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:37:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52583 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaK0Hfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:35:31 -0500
X-AuditID: cbfee691-f79b86d000004a5a-20-5476d43870c2
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
Subject: [PATCH 17/19] arm64: dts: exynos: Add MSHC dt node for Exynos5433
Date: Thu, 27 Nov 2014 16:35:14 +0900
Message-id: <1417073716-22997-18-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTYRjG/c5tZ5J5mLcvo4hBUJb3zT67YUVxKIggKVBIpx1UnDp2VIyE
	pqWBWHgrrZWZqRMdFVPJJHKuEDPUZPMyMJ04Umkm3svLaJf67/e+z8Pz/PG+NC7qIALptMxs
	Tpkpk4spT0LrK+GDkSk3NszUKkEz2lcY2qnoFaDFplKAjN1H0NjqLIlefB4k0XZZEYUqpsoI
	NL5ZTKIHdSMUGii0CVDVtgZDuplREhm7nlGoZugjhhrHhjHUP7ZCoU+2+ySqqZynUG9NA0At
	XdsAzS/1ETH+rLZWC9itzQrAvn/6XcBOjH6g2LaGO6ypr5BkH7a3AHZFt/8KHed58iYnT8vl
	lKGnEz1TNWozUEyK8rSdJaQKrO8uAUIaMhJoM1YTbvaH3ybfUCXAkxYxjQDazTuC/6bfq0bC
	LVQDaDUV4u6hEIOrpnbM6aKYINg9N0452Zc5B1WPCjCnCWeWcKh6PEw6BR/mIlQ3v8WdTDAH
	4eDIiqvbi7kArRYbcNcdgE2aJy6/0LHvXutxsYg5D+vXTa5QyDynocW+8C+IgeuVBkcQ7RD2
	QZ0ed+fsgT3N40QZ8KkDHi3Aj1MkK/ikFKU0hJdl8DmZKSHJWRk64LjmV/uP8k4wpT9hAAwN
	xLu8kD43VkTKcvlbGQYgdTSU44F+yVmOB8jMTgiPjIpAUok0MuJYdJQ4wOvo3j9XRUyKLJtL
	5zgFp0xQ5sg53gAwWhioAnH5bcsqaVbM8SFVe7C5/0x0UVqd98TG8vXQnezWqtioRU189cLZ
	dx16vKA4fDW+tvenr3UoMYxRyRcEJeZ6q0++9PLtpCXqsG0uQLQWvQYPvc4Tpso2bszOfFm8
	ZJk2DkxjOafUOo+EcfFWqeVerfe1X+mVd432UCH9Uj0lFBN8qiw8CFfysr8Jx6zFyAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQV2LK2UhBjOWa1g8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZiyffZOx4J5QxZodXawNjN/4uhg5OSQETCR+fLnM
	AmGLSVy4t56ti5GLQ0hgOqPEkytNzBBOE5PElytbmECq2AS0JPa/uMEGYosIOEs0TG1kAili
	FvjILNEw7SIrSEJYwEti9ooNzCA2i4CqxLmrn8FW8Aq4STx58IYRYp2CxLLlM8HqOYHi+78e
	BLOFBFwlFn27wjSBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODIfya9g3FVg8Uh
	RgEORiUeXosDZSFCrIllxZW5hxglOJiVRHilFgGFeFMSK6tSi/Lji0pzUosPMZoCXTWRWUo0
	OR+YlPJK4g2NTcyMLI3MDS2MjM2VxHlv3MwNERJITyxJzU5NLUgtgulj4uCUamAMDVtif/PB
	nHCGm4rrzr4Muv91Y0mG1nwxyUc3alc7+XbuihbuOPzPwaxsG5uY+ZtNX96suxJnp6rauiHR
	SV1lu2MqT/PJyGLL4AtOu6yqNh+OktL5yzjh+Lw/535fbpL3Vrq4pmY7y8YLLZMfPXq8Kiq7
	tpOt+cQVzZNu7K8lZUqkmjTm+DorsRRnJBpqMRcVJwIAJUBMdhIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaehoon Chung <jh80.chung@samsung.com>

This patch adds MSHC (Mobile Storage Host Controller) dt node for Exynos5433
SoC. MSHC is an interface between the system the SD/MMC card.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 42 ++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index 3d8b576..cfe3de8 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -53,6 +53,9 @@
 		i2c9 = &hsi2c_9;
 		i2c10 = &hsi2c_10;
 		i2c11 = &hsi2c_11;
+		mshc0 = &mshc_0;
+		mshc1 = &mshc_1;
+		mshc2 = &mshc_2;
 	};
 
 	chipid@10000000 {
@@ -507,6 +510,45 @@
 			status = "disabled";
 		};
 
+		mshc_0: mshc@15540000 {
+			compatible = "samsung,exynos7-dw-mshc-smu";
+			interrupts = <0 225 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x15540000 0x2000>;
+			clocks = <&cmu_fsys CLK_ACLK_MMC0>,
+				 <&cmu_fsys CLK_SCLK_MMC0>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x40>;
+			status = "disabled";
+		};
+
+		mshc_1: mshc@15550000 {
+			compatible = "samsung,exynos7-dw-mshc-smu";
+			interrupts = <0 226 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x15550000 0x2000>;
+			clocks = <&cmu_fsys CLK_ACLK_MMC1>,
+				 <&cmu_fsys CLK_SCLK_MMC1>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x40>;
+			status = "disabled";
+		};
+
+		mshc_2: mshc@15560000 {
+			compatible = "samsung,exynos7-dw-mshc-smu";
+			interrupts = <0 227 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x15560000 0x2000>;
+			clocks = <&cmu_fsys CLK_ACLK_MMC2>,
+				 <&cmu_fsys CLK_SCLK_MMC2>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x40>;
+			status = "disabled";
+		};
+
 		timer {
 			compatible = "arm,armv8-timer";
 			interrupts = <1 13 0xff01>,
-- 
1.8.5.5

