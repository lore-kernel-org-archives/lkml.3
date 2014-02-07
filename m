Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaBGIGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:06:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36271 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBGIGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:06:53 -0500
X-AuditID: cbfee68e-b7f566d000002344-9b-52f49414d708
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Jonas Jensen'" <jonas.jensen@gmail.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 05/10] rtc: rtc-moxart: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:06:43 +0900
Message-id: <000e01cf23db$8a0d4850$9e27d8f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAMs6g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zfV2RKV+CDFo+K1osuXiV3WLO+jVs
	FpcXXmK1mPxjH4vF5V1z2Cz2d3YwOrB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGWsfD+ftWAXW8WsE0vZGxhXs3YxcnBICJhI/H4v1cXICWSKSVy4
	t56ti5GLQ0hgGaPE0f5D7BAJE4nLX1axQiQWMUrcenSUEcL5xShx4ulbVpAqNgE1iS9fDrOD
	TBUR0Jdoa9EAqWEW2MEoMWXmdSaQGiEBW4lfn5eA1XMK2EksOnEWzBYWcJfYNH82M4jNIqAq
	cW3jRjCbF6h+5s5vjBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhvhGXeLRX12QsIiAkcTq
	j13sECUiEvtevAO7WULgK7vErDl3oHYJSHybfIgFoldWYtMBZoiHJSUOrrjBMoFRYhaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJ3r4djDcPWB9iTAZaP5FZ
	SjQ5Hxj9eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBseZJhrfU+q+lN3WuKx9mUDAJW/Wo5grL5y+ltkXS2znDt31Slue+UXn5jOhEdsm7anuW
	ciYLPlvzKVD5xTG5n2y3ow3Lpkf3xvW/+da8sptv+cmEDXvr1/16EVay66u/gudznslOsq96
	mZXiZvHYzL+TkJW4/6Jb5rUPMtEFP5jiPjNsvPJknRJLcUaioRZzUXEiAHzQgo/0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV2RKV+CDFpfyFosuXiV3WLO+jVs
	FpcXXmK1mPxjH4vF5V1z2Cz2d3YwOrB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWPl+PmvBLraKWSeWsjcw
	rmbtYuTkkBAwkbj8ZRWULSZx4d56ti5GLg4hgUWMErceHWWEcH4xSpx4+hasik1ATeLLl8Ps
	XYwcHCIC+hJtLRogNcwCOxglpsy8zgRSIyRgK/Hr8xKwek4BO4lFJ86C2cIC7hKb5s9mBrFZ
	BFQlrm3cCGbzAtXP3PmNEcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmL
	CBhJrP7YxQ5RIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0
	L10vOT93EyM4OTyT2sG4ssHiEKMAB6MSD++JpZ+DhFgTy4orcw8xSnAwK4nw/mz4EiTEm5JY
	WZValB9fVJqTWnyIMRno0YnMUqLJ+cDElVcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjD43Wjxt0zQO/43y3qpRNP9bulD6ni97JztLxSzxWDo1VLKfOePe
	021pL5Xi37ypbK25yrd5pzZH3ZwnRtPey7yfutjo7+8rHu9nxE7M76jMzWk4arC7lF9y+qHn
	Mv8e5/+UXP0ocovJlcMrJoS/dqhmz9S5cOH18iil6hzlrmM3/23myRSIEVViKc5INNRiLipO
	BAAbt0IPUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-moxart.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-moxart.c b/drivers/rtc/rtc-moxart.c
index c29dee0..c318462 100644
--- a/drivers/rtc/rtc-moxart.c
+++ b/drivers/rtc/rtc-moxart.c
@@ -247,10 +247,8 @@ static int moxart_rtc_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	moxart_rtc = devm_kzalloc(&pdev->dev, sizeof(*moxart_rtc), GFP_KERNEL);
-	if (!moxart_rtc) {
-		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+	if (!moxart_rtc)
 		return -ENOMEM;
-	}
 
 	moxart_rtc->gpio_data = of_get_named_gpio(pdev->dev.of_node,
 						  "gpio-rtc-data", 0);
-- 
1.7.10.4


