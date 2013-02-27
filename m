Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3B0F66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:58:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60152 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3B0F64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:58:56 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-fe-512da09e13c1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jonghwa Lee'" <jonghwa3.lee@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
In-reply-to: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
Subject: [PATCH 5/5] rtc: max77686: use dev_info()/dev_emerg() instead of
 pr_info()/pr_emerg()
Date: Wed, 27 Feb 2013 14:58:54 +0900
Message-id: <009301ce14af$863d9c20$92b8d460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Ur0Jf3bJm/gOXS5uxDgC3uRXcVgAADaJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zY915C3QDDRo3W1osuXiV3WLO+jVs
	FpcXXmK16Dz7hNni8q45bBb7OzsYHdg89kw8yeZxYsZvFo++LasYPabP+8nk8XmTXABrFJdN
	SmpOZllqkb5dAlfG9N0PWQpeclecmfOZrYHxEWcXIyeHhICJxJaTp5ggbDGJC/fWs3UxcnEI
	CSxjlFj2fDYzTNGl3k5WiMR0RomTZ/YygiSEBH4xSjz4LwxiswmoSXz5cpi9i5GDQ0RAX6Kt
	RQOknllgJ6PEw9W3oeptJTb9OMsGYnMK2Eks/LqVDaReWCBBYsXTapAwi4CqRNO3CcwgYV6g
	8i3vi0DCvAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe8xasXEJAXeLRX12QsIiAkcSMe5vZIUpE
	JPa9eMcIco2EwFt2ie//N7JArBKQ+Db5EAtEr6zEpgNQ30pKHFxxg2UCo8QsJJtnIdk8C8nm
	WUhWLGBkWcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kREq99OxhvHrA+xJgMtH4is5Rocj4w
	3vNK4g2NjU3MTExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTH/
	HMspB1OnDP1H+hGGO3PPb7vfwWZ/8KWKmeEKgcLLFSFnzl/3sFU/F854fNsjbfV5mguPWnC8
	ip+yITnq6bHugKLXzfV9pben3xN4pPRf1paHTVlr96wPmysfqd+5fSbj/qPuyq2aC8yb7mS1
	OTKofbwudjqi7dVZHn7NrXIHJD+zZAcwXlViKc5INNRiLipOBABYLqAm7QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd15C3QDDd5cMbFYcvEqu8Wc9WvY
	LC4vvMRq0Xn2CbPF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB59W1Yxekyf95PJ4/MmuQDWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGdN3P2QpeMldcWbOZ7YGxkecXYyc
	HBICJhKXejtZIWwxiQv31rN1MXJxCAlMZ5Q4eWYvI0hCSOAXo8SD/8IgNpuAmsSXL4fZuxg5
	OEQE9CXaWjRA6pkFdjJKPFx9G6reVmLTj7NsIDangJ3Ewq9b2UDqhQUSJFY8rQYJswioSjR9
	m8AMEuYFKt/yvggkzCsgKPFj8j0WEJtZQEti/c7jTBC2vMTmNW/ByiUE1CUe/dUFCYsIGEnM
	uLeZHaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5y
	fu4mRnAyeCa1g3Flg8UhRgEORiUe3gWXdAKFWBPLiitzDzFKcDArifB+PAAU4k1JrKxKLcqP
	LyrNSS0+xJgM9OdEZinR5HxgosoriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTU
	gtQimC1MHJxSDYwKladnOoSeMOiIP71/3qH/M1XEOLYG9TEYizHtseaZ5NKW+WHC04ufbt5p
	DD3RdFjqmcn1FraFle1uc35Ml+hs4o7nXjD/raP4gozCiptGxgcOKjdt8SoqZ3UNXTLtmek8
	zji5e1eE7p+uFM0ya6sWq3DwnK4RMpGhpPh+95Jv5vl98ceYJiqxFGckGmoxFxUnAgBVtODl
	SgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_info()/dev_emerg() are more preferred than pr_info()/pr_emerg().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 9de93e7..df66bab 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -466,7 +466,7 @@ static void max77686_rtc_enable_smpl(struct max77686_rtc_info *info, bool enable
 
 	val = 0;
 	regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
-	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
+	dev_info(info->dev, "%s: WTSR_SMPL(0x%02x)\n", __func__, val);
 }
 #endif /* MAX77686_RTC_WTSR_SMPL */
 
@@ -589,11 +589,14 @@ static void max77686_rtc_shutdown(struct platform_device *pdev)
 	for (i = 0; i < 3; i++) {
 		max77686_rtc_enable_wtsr(info, false);
 		regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
-		pr_info("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
-		if (val & WTSR_EN_MASK)
-			pr_emerg("%s: fail to disable WTSR\n", __func__);
-		else {
-			pr_info("%s: success to disable WTSR\n", __func__);
+		dev_info(info->dev, "%s: WTSR_SMPL reg(0x%02x)\n", __func__,
+				val);
+		if (val & WTSR_EN_MASK) {
+			dev_emerg(info->dev, "%s: fail to disable WTSR\n",
+					__func__);
+		} else {
+			dev_info(info->dev, "%s: success to disable WTSR\n",
+					__func__);
 			break;
 		}
 	}
-- 
1.7.2.5


