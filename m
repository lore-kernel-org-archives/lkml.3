Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbbAOBvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:51:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9446 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbbAOBvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:07 -0500
X-AuditID: cbfee691-f79b86d000004a5a-2e-54b71d080f75
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 3/9] ARM: dts: Add memory bus node for Exynos3250
Date: Thu, 15 Jan 2015 10:50:51 +0900
Message-id: <1421286657-4720-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSoMshuz3EoGG3lsXjNYuZLDbOWM9q
	cf3Lc1aLSfcnsFi8fmFo0f/4NbPF2aY37BabHl9jtbi8aw6bxefeI4wWM87vY7JYev0ik8Xt
	xhVsFo9XvGW3aN17hN1i1a4/jA4CHmvmrWH02DnrLrvH4j0vmTw2repk89i8pN6jb8sqRo/P
	m+QC2KO4bFJSczLLUov07RK4MnoXbGYq2Clbsf+QdAPjZZEuRg4OCQETiUlvjbsYOYFMMYkL
	99azdTFycQgJLGWUmPh4FxtEwkRi6sNOqMR0Rokfi96AJYQEmpgknjZlg9hsAloS+1/cAIuL
	COhJdB7bww5iMwv8YZJo2sQCYgsLuEgsvNfEDGKzCKhKXGqcD1bDCxR/efUvC8QyBYlly2ey
	gticAq4SPb/2s0PscpFYdXcyI8gREgKP2CWOvehghRgkIPFt8iEWiG9kJTYdYIaYIylxcMUN
	lgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbT6X/PJu5gvH/A+hCjAAejEg+v
	w5GtIUKsiWXFlbmHGE2BNkxklhJNzgfGbF5JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYw7XqedD5r7rfHxZJ6E9U07Ra2mb3q3Yeusha8FDBk3mjH8
	vHW3I3bFuT9ebaY1sjUMX6Ybq8/6a3OgN+bn+5eLuYzb5Cb1vvi6Z6d2+Jz3qRp8+3WrHlW3
	f663ZS5MKchVvKhhFCRxYzvrt3kMH76V/Cp4JTN/T+jDxbzzth1aNUNuB/+zPsvLSizFGYmG
	WsxFxYkAlqzRTqECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQV0O2e0hBlOuKFs8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNG74LNTAU7ZSv2H5Ju
	YLws0sXIySEhYCIx9WEnG4QtJnHh3nogm4tDSGA6o8SPRW/AEkICTUwST5uyQWw2AS2J/S9u
	gMVFBPQkOo/tYQexmQX+MEk0bWIBsYUFXCQW3mtiBrFZBFQlLjXOB6vhBYq/vPqXBWKZgsSy
	5TNZQWxOAVeJnl/72SF2uUisujuZcQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wdH6TGoH48oGi0OMAhyMSjy8Dke2hgixJpYVV+YeYpTgYFYS4X37aVuIEG9KYmVValF+fFFp
	TmrxIUZToKsmMkuJJucDE0leSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwf
	EwenVAMjr5h6THTWJk5G9/gCZaH8yzHJm9Veb921ydX3rcXsDey73Tsz+LYdrp/B0MZ92Gd5
	rfkSoaaLP4s1I/w+Zk1P/2889a7Ofo6knR7vy9umSLH+sH1TM++54hzV6g+O5osVV2y7zRux
	etpGx5Kje2OWxbiGud04/INj2tTPz36ppV263vup4VGSEktxRqKhFnNRcSIA+xh/lewCAAA=
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

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Myungjoo Ham <myungjoo.ham@samsung.com>
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

