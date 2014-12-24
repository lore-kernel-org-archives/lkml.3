Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaLXFql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:46:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaLXFpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:45:40 -0500
X-AuditID: cbfee68d-f79296d000004278-c4-549a530035a4
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 1/4] ARM: dts: Add exynos_usbphy node for exynos3250
Date: Wed, 24 Dec 2014 14:45:30 +0900
Message-id: <1419399933-3707-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkUJcheFaIwfFL+hbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmi7VH7rI7sHtsWtXJ5tG3ZRWjx+dNcgHMUVw2Kak5mWWp
	Rfp2CVwZ935sZytoZK84f+kqcwPjNdYuRk4OCQETibmTVjNC2GISF+6tZ+ti5OIQEljKKPH0
	521GmKJnpz5BJRYxSnyYdwSsW0igjUli2UxvEJtNQFvi+/rFQHEODhEBP4llL3VB6pkF1jNK
	7Nhwiw2kRljAXaJr2n2woSwCqhJXN/wCs3mB4sem7mcC6ZUQUJCYM8kGJMwp4CHxdOtBRohV
	7hI/1z5gBZkpIdDNLnHhRgcTxBwBiW+TD7FA9MpKbDrADHGzpMTBFTdYJjAKL2BkWMUomlqQ
	XFCclF5kqFecmFtcmpeul5yfu4kRGNCn/z3r3cF4+4D1IUYBDkYlHt4FZ2aECLEmlhVX5h5i
	NAXaMJFZSjQ5Hxg3eSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MM7Merb2zMo7eh6sty7NCmHm3n1781ujOI/7ZcrfyzwWGHcz2uqGR+zKmL3owvuK
	1WwPsj+vMY0VrJg2a779j+XLj1nGfBZaEPmHV3dt6F1+/tonRyuvRZ8U27zJXf/dZUWza1v7
	hVr4U8V32PxXYF7gF9k47Ytfblh/u5yd+iv7eg116VP/vymxFGckGmoxFxUnAgBYXAMqYwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAV2G4FkhBrM/alhc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZLdYeucvuwO6xaVUnm0ffllWMHp83yQUwRzUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZtz7sZ2toJG94vylq8wNjNdYuxg5OSQETCSe
	nfrEBmGLSVy4tx7I5uIQEljEKPFh3hGwIiGBNiaJZTO9QWw2AW2J7+sXA8U5OEQE/CSWvdQF
	qWcWWM8osWPDLbBBwgLuEl3T7jOC2CwCqhJXN/wCs3mB4sem7mcC6ZUQUJCYM8kGJMwp4CHx
	dOtBRohV7hI/1z5gncDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcLw8k97BuKrB
	4hCjAAejEg/vgjMzQoRYE8uKK3MPMUpwMCuJ8OrcmBkixJuSWFmVWpQfX1Sak1p8iNEU6KiJ
	zFKiyfnAWM4riTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamA0kZjj
	PzH4hnrFtlo12ZA/svK65jHFx0XP7P3zN9lCyPTph4s8Czb7fVz74NRuxZpnufHM0cXHnN//
	DQ3c+rf33Hz7Dr6/i0r89RwckoIZF1qkT+yqV2Q9+u6/Z0Br/+6jZyc/rJ4Q7151WvyYyUwe
	yTt+1S+3fYn4yDH3jeLUqsit0ke2/GZUYinOSDTUYi4qTgQA3Wwrbq0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for exynos_usbphy to use USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2246549..27d385f 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -279,6 +279,16 @@
 			status = "disabled";
 		};
 
+		exynos_usbphy: exynos-usbphy@125B0000 {
+			compatible = "samsung,exynos3250-usb2-phy";
+			reg = <0x125B0000 0x100>;
+			samsung,pmureg-phandle = <&pmu_system_controller>;
+			clocks = <&cmu CLK_USBOTG>, <&cmu CLK_SCLK_UPLL>;
+			clock-names = "phy", "ref";
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
 		amba {
 			compatible = "arm,amba-bus";
 			#address-cells = <1>;
-- 
1.7.9.5

