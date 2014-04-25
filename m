Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaDYLjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:39:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38679 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaDYLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:36:35 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-5e-535a48c209e0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 4/5] arm: dts: Add syscon handle in pmu node for exynos5420
Date: Fri, 25 Apr 2014 20:54:16 +0900
Message-id: <1398426857-5097-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t8zQ91DHlHBBh97TSyWTbrLZjH/yDlW
	i94FV9ksNj2+xmpxedccNosZ5/cxWSza+oXdonXvEXaL9TNes1jsaFnN4sDlsWlVJ5vH5iX1
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJUxc+4k9oIzrBVrp95kamC8w9LFyMkhIWAi0b17
	IjOELSZx4d56ti5GLg4hgWWMEsuOrWDsYuQAK2qbyQ4RX8Qo8WnKdFYIp41J4vm+7awg3WwC
	uhJP3s9lBkmICLQzSvy7+hBsFLPAXEaJ5vYL7CBVwgJ+Et+nXWcBGcsioCpx6H0giMkr4C5x
	/boJxDIFiTmTbECKOQU8JM7PWAe1uBVo5JzPjCCOhMA6domemdfAzmYREJD4NvkQC0SzrMSm
	A1DfSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIYHfv4Px7gHrQ4zJ
	QOMmMkuJJucDIyevJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTDWdx7dvemR3rwP1uYpbdciJ1vMM2l335nDyrrjPl9c/noJ68SXwka1h9SeK4nG
	eAqfkjfjS/72sDd43/6isrnPrkuLvuY1ZJzR/SJ1g3zv0V6LhiTOSH417ol7rTaf+9x9srLn
	XEWvYbDExCN+f1YdsmL8P21LkiFLyFXZXy0fuDv2/xYt8VZiKc5INNRiLipOBACPCp/pkgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAd1DHlHBBmfO61ssm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxsy5k9gL
	zrBWrJ16k6mB8Q5LFyMHh4SAiUTbTPYuRk4gU0ziwr31bF2MXBxCAosYJT5Nmc4K4bQxSTzf
	t50VpIpNQFfiyfu5zCAJEYF2Rol/Vx+CtTALzGWUaG6/ADZLWMBP4vu062ArWARUJQ69DwQx
	eQXcJa5fN4FYrCAxZ5INSDGngIfE+Rnr2CF2tQKNnPOZcQIj7wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwXH1THoH46oGi0OMAhyMSjy8E2Qjg4VYE8uKK3MPMUpwMCuJ8La7RgUL
	8aYkVlalFuXHF5XmpBYfYkwGumkis5Rocj4w5vNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0o
	JJCeWJKanZpakFoEs4WJg1OqgdFp+yfDSw+dUw/GnV7/5E6PuJEvy3yrl+vzL4sq32Tam8YS
	cOWDpYF5/JrlrB8enwkuELu8bEoUQ8tsy4Ou635z3FTZdP7QLuvJNm4lF0QN7148aHj2o4JG
	zr8ddadTA72Pb3sQdZmLz9hr91SF5w61Kb/q529gObK/M9F2ySnXPcxTe37amx9VYinOSDTU
	Yi4qTgQASyQpke8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "samsung,syscon-phandle" property pointing to PMU node
to access PMU register via PMU regmap handle.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index c3a9a66..c6e449d 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -673,6 +673,7 @@
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5420-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
+		samsung,syscon-phandle = <&pmu_system_controller>;
 	};
 
 	tmu_cpu0: tmu@10060000 {
-- 
1.7.10.4

