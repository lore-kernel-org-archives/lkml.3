Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030255AbaDJKHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965751AbaDJKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:52 -0400
X-AuditID: cbfee690-b7f266d00000287c-71-53466d1ecba1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/27] ARM: dts: exynos3250: Add uart dt node to support seiral
 ports
Date: Thu, 10 Apr 2014 19:06:05 +0900
Message-id: <1397124377-16969-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWFcu1y3Y4G2PuMX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLPbunMzowO2xeUm9
	R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGXMelBScJez4uO35UwNjA0cXYycHBICJhKNB5Yx
	QthiEhfurWfrYuTiEBJYyijx/tlxVpiidcu7oBKLGCX6FhxmhnCamCS2bLgLVsUmoCWx/8UN
	NhBbRCBA4sfxd2A2s8BNRolj78NAbGGBcIm3Z1awgNgsAqoS3/6+ZwKxeQVcJX7P/8EMsU1O
	4sOeR+wgNqeAm8TMRSfB5ggB1fQ8ugi2WEJgFbvE+Sk9jBCDBCS+TT4ENJQDKCErsekA1BxJ
	iYMrbrBMYBRewMiwilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMw8E//ezZhB+O9A9aHGJOB
	xk1klhJNzgdGTl5JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MLq8d5zVVTP3xk2OF//yNBwv363WvHNYVNFUYF6R37FD8ocWcaeLr9q3uG6vnkiO
	8dwkN/b9q23nLv7/9N7teXsY5jJKzU9j3MwvJBVxY8+RBw//c933VHr+2uJ0oDdX875TW87G
	2Bdtf6JlKH8yyeeoXI898yw9wZoTueHnt/1mvDL78Me5H+qVWIozEg21mIuKEwFPnwMukgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV25XLdggy2T+S2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqwHJQV3
	OSs+flvO1MDYwNHFyMkhIWAisW55FxuELSZx4d56IJuLQ0hgEaNE34LDzBBOE5PElg13WUGq
	2AS0JPa/uAHWISIQIPHj+Dswm1ngJqPEsfdhILawQLjE2zMrWEBsFgFViW9/3zOB2LwCrhK/
	5/9ghtgmJ/FhzyN2EJtTwE1i5qKTYHOEgGp6Hl1knsDIu4CRYRWjaGpBckFxUnqukV5xYm5x
	aV66XnJ+7iZGcFw9k97BuKrB4hCjAAejEg/vgWWuwUKsiWXFlbmHGCU4mJVEeHdnugUL8aYk
	VlalFuXHF5XmpBYfYkwGumois5Rocj4w5vNK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCe
	WJKanZpakFoEs4WJg1OqgdHAy5KvQW7B7xKHmU7K0wt3Toibvbbw2/4/ZW8+8ZRK573av9H6
	0MSU+XuajPtdwibzlN5VmqFo0ZHdMeEyl2Xmvdrzp3pi4k59WxgxoeXa2W17ZrAdsLw05xrj
	8sNb2Ku8fYWna9gLMX+zb7hY3SXw5uxE43naWevOvVP/W72Xsf6I42thzYdKLMUZiYZazEXF
	iQBrzOzu7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add UART dt node for Exynos3250. Exynos3250 uses same UART IP
of Exynos4 SoC and has only two independent channels.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[Fix incorrect clock id by Tomasz Figa]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 758913e..d17ed54 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -74,4 +74,22 @@
 		reg = <0x11400000 0x1000>;
 		interrupts = <0 240 0>;
 	};
+
+	serial@13800000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13800000 0x100>;
+		interrupts = <0 109 0>;
+		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+		status = "disabled";
+	};
+
+	serial@13810000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13810000 0x100>;
+		interrupts = <0 110 0>;
+		clocks = <&cmu CLK_UART1>, <&cmu CLK_SCLK_UART1>;
+		clock-names = "uart", "clk_uart_baud0";
+		status = "disabled";
+	};
 };
-- 
1.8.0

