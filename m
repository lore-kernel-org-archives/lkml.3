Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbaKLClv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:41:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:51235 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaKLClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:41:16 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4b-5462c8c7bad8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] ARM: dts: Fix the number of DMA channels for Exynos3250
Date: Wed, 12 Nov 2014 11:41:07 +0900
Message-id: <1415760068-765-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1415760068-765-1-git-send-email-cw00.choi@samsung.com>
References: <1415760068-765-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkQPf4iaQQg48f5CwmrTvAZHH9y3NW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38fkwO7xd9ULZo/NS+o9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK+PsrEfsBVPZKz4u+MTYwHictYuRk0NCwETiw5Un7BC2mMSFe+vZuhi5OIQE
	ljJKNJ7+AZTgACtae0MZIj6dUeLV5IPMEE4Tk8TCnqdMIN1sAloS+1/cYAOxRQQkJZoa/oAV
	MQtsYZT4vv8w2AphAR+Jmc+2gBWxCKhKrPr/hBlkA6+As8S5Tc4QVyhILFs+E+w6TgEXiYcb
	ToHNFwIqWdT1Guw6CYHJ7BL33mxlhJgjIPFt8iEWiEtlJTYdYIaYIylxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBIb26X/P+nYw3jxgfYhRgINRiYc3Y3NSiBBrYllx
	Ze4hRlOgDROZpUST84ERlFcSb2hsZmRhamJqbGRuaaYkzpsg9TNYSCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA+OsTbEOLj1bK/WfFaaw600OF9zI9WN3qsQZTj9VoBNy5rU+/n/j8IZeY99J
	N57vzBZhW88V7Ch57IO4cuAD21XhV7JOx6aY+d2TjlzqfuJUzQpGg/fnzI6fFDnSduJ56pTL
	P08GdjHrrT/kbxC3UWfWbb4JZ44f0V2zlZ3r/5w/ch8+pt7ljlRiKc5INNRiLipOBAApZvv5
	aAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd3jJ5JCDB62SVhMWneAyeL6l+es
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/Jgd3j76oXzB6bl9R79G1ZxejxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMs7MesRdMZa/4uOATYwPjcdYuRg4O
	CQETibU3lLsYOYFMMYkL99azdTFycQgJTGeUeDX5IDOE08QksbDnKRNIFZuAlsT+FzfYQGwR
	AUmJpoY/YEXMAlsYJb7vP8wOkhAW8JGY+WwLWBGLgKrEqv9PmEG28Qo4S5zb5AyxTUFi2fKZ
	rCA2p4CLxMMNp8DmCwGVLOp6zTaBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODI
	eSa9g3FVg8UhRgEORiUe3ozNSSFCrIllxZW5hxglOJiVRHgfLAUK8aYkVlalFuXHF5XmpBYf
	YjQFOmois5Rocj4wqvNK4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBK
	NTD2LUg8xfRMefOh6R4Pe2qSa09t8wm7kt7m9friIyMdERk1SdbtNuszJscoS74xVuaukU6c
	8zn5yfN/0zJm//C8wBF4Y/+0gAV1s9iubWXV3pnLVS8n0f7liJPv9k59sVPX/G94Ttm9LPhX
	xcIVh8Q2MdsuPfIwgGvi9/Ocm1k1PRafcHq7Qv+UEktxRqKhFnNRcSIAs/4ORLICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the numer for DMA channels for Exynos3250 because DMA controller
of Exynos3250 can support 16 channels simultaneously.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 242ddda..5c14e3e 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -292,7 +292,7 @@
 				clocks = <&cmu CLK_PDMA0>;
 				clock-names = "apb_pclk";
 				#dma-cells = <1>;
-				#dma-channels = <8>;
+				#dma-channels = <16>;
 				#dma-requests = <32>;
 			};
 
@@ -303,7 +303,7 @@
 				clocks = <&cmu CLK_PDMA1>;
 				clock-names = "apb_pclk";
 				#dma-cells = <1>;
-				#dma-channels = <8>;
+				#dma-channels = <16;
 				#dma-requests = <32>;
 			};
 		};
-- 
1.8.5.5

