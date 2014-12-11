Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaLKMLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:11:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22872 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaLKMLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:11:08 -0500
X-AuditID: cbfee68f-f791c6d000004834-05-548989db7550
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kishon@ti.com, k.debski@samsung.com, kgene@kernel.org,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 1/4] Doc/devicetree: bindings: Update bindings information for
 USB3.0 DRD PHY
Date: Thu, 11 Dec 2014 17:32:44 +0530
Message-id: <1418299367-2412-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
References: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkRvd2Z2eIweUdwhbzj5xjtWi7cpDd
	4vLCS6wWP15fYLPof/ya2eLC0x42i8u75rBZzDi/j8li0bJWZovWvUfYHbg8Nq3qZPPo27KK
	0eP4je1MHp83yQWwRHHZpKTmZJalFunbJXBlzDn/l6lgB3fFv9aH7A2M2zm7GDk5JARMJBp6
	9rBD2GISF+6tZ+ti5OIQEljKKHHw3yVGmKI7nz6yQyQWMUqcX3acGcKZwCSx+sFSsHY2AV2J
	pre7wDpEBGokpty6AtbBLNDLKPHvwznWLkYODmGBeIlju0NBTBYBVYnd8/1AynkF3CVuvfjD
	BrFMTmLLrUdgIzkFPCQW9fxkASkXAqq52qsJMlFCYBW7xIm/f8FqWAQEJL5NPgRWIyEgK7Hp
	ADPEGEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzDwT/971r+D8e4B
	60OMAhyMSjy8GfGdIUKsiWXFlbmHGE2BNkxklhJNzgfGV15JvKGxmZGFqYmpsZG5pZmSOO9C
	qZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhb9ZZ8nnavtOrGynzvhhDpTddZ3t1k2Hxw
	w8fX5sdym7MqFjh0tTfX2CxZVKfM9WGS9sXdJpNuNChY7p8tvl37Z0TkxPD/M3/pqZ95uaNn
	cp1wxZmfCSG/72dKzdm2bFL1t+Zkfc2WKSxH76UZTU3ylL0msv7GMfXk5Q/uMh4tkJUMdMzo
	qNFTYinOSDTUYi4qTgQA+r76sHcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jAd3bnZ0hBjMWcVnMP3KO1aLtykF2
	i8sLL7Fa/Hh9gc2i//FrZosLT3vYLC7vmsNmMeP8PiaLRctamS1a9x5hd+Dy2LSqk82jb8sq
	Ro/jN7YzeXzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
	q+TiE6DrlpkDdJGSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPO+b9M
	BTu4K/61PmRvYNzO2cXIySEhYCJx59NHdghbTOLCvfVsXYxcHEICixglzi87zgzhTGCSWP1g
	KVgVm4CuRNPbXYwgtohAjcSUW1fYQYqYBXoZJf59OMfaxcjBISwQL3FsdyiIySKgKrF7vh9I
	Oa+Au8StF3/YIJbJSWy59QhsJKeAh8Sinp8sIOVCQDVXezUnMPIuYGRYxSiaWpBcUJyUnmuo
	V5yYW1yal66XnJ+7iREcV8+kdjCubLA4xCjAwajEw5sR3xkixJpYVlyZe4hRgoNZSYTXKgIo
	xJuSWFmVWpQfX1Sak1p8iNEU6KaJzFKiyfnAmM8riTc0NjE3NTa1NLEwMbNUEudVsm8LERJI
	TyxJzU5NLUgtgulj4uCUamDMMO1RWzf7M7dn2aazGe18XlGv9h7Im9F44q7eMYuF/74FBi32
	zTaxdPs6td7x+lxhO3/fPtuTr5678288vT62wDtSqXHJk7L3l27/PJMpoc4bFm79h+PJTP/j
	739fffrnk3u3ZewDi8Al/H+qAzO1ZtTd+qPtc1p4sU/8Tvkjmof39Muu+xOixFKckWioxVxU
	nAgAhTs9F8ECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing VBUS-supply information and consumer usage information for
USB 3.0 DRD PHY.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 Documentation/devicetree/bindings/phy/samsung-phy.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index d5bad92..0090ad1 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -148,6 +148,9 @@ Required properties:
 		      control pmu registers for power isolation.
 - #phy-cells : from the generic PHY bindings, must be 1;
 
+Optional properties:
+- vbus-supply : Reference to regulator node which supplies VBUS on the PHY.
+
 For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
 compatible PHYs, the second cell in the PHY specifier identifies the
 PHY id, which is interpreted as follows:
@@ -164,6 +167,12 @@ Example:
 		#phy-cells = <1>;
 	};
 
+Then the PHY can be used in other nodes such as:
+	phy-consumer@12340000 {
+		phys = <&usbdrd_phy 0>, <&usbdrd_phy 1>;
+		phy-names = "usb2-phy", "usb3-phy";
+	};
+
 - aliases: For SoCs like Exynos5420 having multiple USB 3.0 DRD PHY controllers,
 	   'usbdrd_phy' nodes should have numbered alias in the aliases node,
 	   in the form of usbdrdphyN, N = 0, 1... (depending on number of
-- 
1.7.10.4

