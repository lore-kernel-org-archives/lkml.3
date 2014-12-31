Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaLaFV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:21:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38595 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaLaFUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:20:01 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ee-54a3877aa329
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 3/8] ARM: dts: Add memory bus node for Exynos3250
Date: Wed, 31 Dec 2014 14:19:47 +0900
Message-id: <1420003192-5576-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSrFvVvjjE4G+fpcXjNYuZLDbOWM9q
	cf3Lc1aLSfcnsFi8fmFo0bvgKpvF2aY37BabHl9jtbi8aw6bxefeI4wWM87vY7JYev0ik8Xt
	xhVsFo9XvGW3WLXrD6MDv8eaeWsYPXbOusvusXjPSyaPzUvqPfq2rGL0+LxJLoAtissmJTUn
	syy1SN8ugSvj/asnjAXdshUfjlc3MK4S6WLk4JAQMJE4sjSui5ETyBSTuHBvPVsXIxeHkMBS
	Rol5d3ezQCRMJOY/mwxmCwksYpRYedwUoqiJSWLKralgCTYBLYn9L26wgdgiAjISVzduZwEp
	Yhb4zyTx+NVyVpBtwgLuEkveVoDUsAioSnT+XMQIYvMKuEj8mbKGHWKZgsSy5TPByjkFXCUm
	fHGG2OsiMWNLMxPISAmBa+wS2091MULMEZD4NvkQC8QzshKbDjBDjJGUOLjiBssERuEFjAyr
	GEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj5vS/Z307GG8esD7EKMDBqMTDe8NucYgQa2JZ
	cWXuIUZToA0TmaVEk/OB0ZlXEm9obGZkYWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVANjyEprtq1xwlePaZxo0LW8t1q/f+PiD8nllxurH11mbfxl+GyqpqTFkdCa
	YxdnG7A9NljfVOJy715ddIBYerNAY0ZJ9vaFk/4mLFoSriDtcIjn3PlIvWUlXq+nz1tXW3Xk
	ufKRo2IOOlwZpsVGj9ZcSvwQWLD/uezEmx/7NnFbL/G+sI7X7Wa2EktxRqKhFnNRcSIAdRTM
	N5YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAd2q9sUhBmtWq1s8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2Lyk3qNvyypGj8+b5ALYohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZrx/9YSxoFu24sPx6gbGVSJdjJwcEgIm
	EvOfTWaBsMUkLtxbzwZiCwksYpRYedy0i5ELyG5ikphyaypYEZuAlsT+FzfAikQEZCSubtzO
	AlLELPCfSeLxq+WsXYwcHMIC7hJL3laA1LAIqEp0/lzECGLzCrhI/Jmyhh1imYLEsuUzwco5
	BVwlJnxxhtjrIjFjSzPTBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/KZ1A7G
	lQ0WhxgFOBiVeHhv2C0OEWJNLCuuzD3EKMHBrCTCe1kTKMSbklhZlVqUH19UmpNafIjRFOio
	icxSosn5wJSRVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAuGjO
	4sgwBu/qyzz9ZuePrcmKClNS5/6tnfMq8VebwTTlloDWmXMurkl06pS/fXt239oP5q/feLuu
	8xRuD9t85GTlp4q/TEd2XVvUyXWTeV68uw+3zJ6n5SfOZAgta/hsdrFU8rO39np1u+1Hf1kn
	Hvv+oOjtqffhr1y8ZaZt/5SxzvRtd3KjuxJLcUaioRZzUXEiAPyU3izhAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the memory bus node for Exynos3250 SoC. Exynos3250 has
following memory buses to translate data between DRAM and eMMC/sub-IPs.

Following list specifies the detailed relation between memory bus clock and DMC
IP in MIF (Memory Interface) block:
- DMC clock : DMC (Dynamic Memory Controller)

Following list specifies the detailed relation between memory bus clock and
sub-IPs in INT (Internal) block:
- ACLK100 clock : PERIL
- ACLK160 clock : LCD0
- ACLK200 clock : FSYS
- ACLK266 clock : ISP
- GDL/GDR clock : leftbus/rightbus
- SCLK_MFC clock : MFC

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 125 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 9ed1260..3eaed53 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -99,6 +99,131 @@
 			};
 		};
 
+		memory_bus_mif: memory_bus@0 {
+			compatible = "samsung,exynos-memory-bus";
+
+			operating-points = <
+				400000 875000
+				200000 800000
+				133000 800000
+				100000 800000
+				50000  800000>;
+			status = "disabled";
+
+			blocks {
+				dmc_block: memory_bus_block1 {
+					clocks = <&cmu_dmc CLK_DIV_DMC>;
+					clock-names = "memory-bus";
+					frequency = <
+						400000
+						200000
+						133000
+						100000
+						50000>;
+				};
+			};
+		};
+
+		memory_bus_int: memory_bus@1 {
+			compatible = "samsung,exynos-memory-bus";
+
+			operating-points = <
+				400000 950000
+				200000 950000
+				133000 925000
+				100000 850000
+				80000  850000
+				50000  850000>;
+
+			status = "disabled";
+
+			blocks {
+				peril_block: memory_bus_block1 {
+					clocks = <&cmu CLK_DIV_ACLK_100>;
+					clock-names = "memory-bus";
+					frequency = <
+						100000
+						100000
+						100000
+						100000
+						50000
+						50000>;
+				};
+
+				lcd0_block: memory_bus_block2 {
+					clocks = <&cmu CLK_DIV_ACLK_160>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						160000
+						100000
+						80000
+						80000
+						50000>;
+				};
+
+				fsys_block: memory_bus_block3 {
+					clocks = <&cmu CLK_DIV_ACLK_200>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						100000
+						80000
+						50000
+						50000>;
+				};
+
+				isp_block: memory_bus_block4 {
+					clocks = <&cmu CLK_DIV_ACLK_266>;
+					clock-names = "memory-bus";
+					frequency = <
+						300000
+						200000
+						133000
+						100000
+						50000
+						50000>;
+				};
+
+				leftbus_block: memory_bus_block5 {
+					clocks = <&cmu CLK_DIV_GDL>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						133000
+						100000
+						100000
+						100000>;
+				};
+
+				rightbus_block: memory_bus_block6 {
+					clocks = <&cmu CLK_DIV_GDR>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						133000
+						100000
+						100000
+						100000>;
+				};
+
+				mfc_block: memory_bus_block7 {
+					clocks = <&cmu CLK_SCLK_MFC>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						200000
+						133000
+						100000
+						80000>;
+				};
+			};
+		};
+
 		sysram@02020000 {
 			compatible = "mmio-sram";
 			reg = <0x02020000 0x40000>;
-- 
1.8.5.5

