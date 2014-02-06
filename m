Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaBFIZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:25:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:8332 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaBFIZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:25:35 -0500
X-AuditID: cbfee68e-b7f566d000002344-fb-52f346fd68e9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Johan Hovold'" <jhovold@gmail.com>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 09/12] backlight: lm3533_bl: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:25:33 +0900
Message-id: <000a01cf2315$0110d740$033285c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAXagw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI92/bp+DDL7fMbaYs34Nm8XlhZdY
	Lfaukra4vGsOmwOLx85Zd9k9Tsz4zeLRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGev6nrMU
	rGerOPJAtIFxAWsXIyeHhICJxInDx1ggbDGJC/fWs3UxcnEICSxjlPh4vIOpi5EDrGjtdW6I
	+HRGibblb1ghnF+MEt+e9DKBdLMJqEl8+XKYHaRBREBfoq1FAyTMLJAlcfb2ZWYQW0jAVmL3
	6ZNgizkF7CS2fWoFaxUW8JH49rKHEcRmEVCVuHLhOBuIzQtU//XQImYIW1Dix+R7LBAztSTW
	7zzOBGHLS2xe85YZ4k51iUd/dUHCIgJGEl1Xb0KVi0jse/GOEeLHU+wSHzrNIFYJSHybfIgF
	olVWYtMBZogSSYmDK26wTGCUmIVk8Swki2chWTwLyYYFjCyrGEVTC5ILipPSi4z0ihNzi0vz
	0vWS83M3MUKisW8H480D1ocYk4HWT2SWEk3OB0ZzXkm8obGZkYWpiamxkbmlGWnCSuK8ix4m
	BQkJpCeWpGanphakFsUXleakFh9iZOLglGpgrEvcuZN/SYX6y+L5lTx7mwO5azWsq8q0iz/f
	dhJaeMRg9ysOtc3FDC2r7bxm1pn+aH1Y98Dhftckya9+dxkTQ60rTXbquv888CFCl3vyUbbN
	ny3l72hfEeD+wLezp3POZ4+jEbwxeizbROofvJ1RKbjJ786u+383XJztOLNhYekqtkWTNKNS
	lFiKMxINtZiLihMByOlxWNwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd2/bp+DDGZ0GljMWb+GzeLywkus
	FntXSVtc3jWHzYHFY+esu+weJ2b8ZvHo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xox1fc9ZCtazVRx5INrAuIC1i5GDQ0LARGLtde4uRk4gU0ziwr31
	bF2MXBxCAtMZJdqWv2GFcH4xSnx70ssEUsUmoCbx5cthdpBmEQF9ibYWDZAws0CWxNnbl5lB
	bCEBW4ndp0+ygticAnYS2z61grUKC/hIfHvZwwhiswioSly5cJwNxOYFqv96aBEzhC0o8WPy
	PRaImVoS63ceZ4Kw5SU2r3nLDHGzusSjv7ogYREBI4muqzehykUk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/sz6R2MqxosDjEKcDAq8fBu
	WP8pSIg1say4MvcQowQHs5II71bzz0FCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MRHkl
	8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwBjep7zyS+/hKQdN
	mPTVxL9fajyxPYqlacHJtuo+xdr7zn7zBTku3Q1rry8TSp5aeS3QxnnDfPZk4U+z4rkfrzs8
	nXWthn5zoaPytaDl/0qa/3lq7F//XFpq/4Xzn4+/bS57vpiprWCaR+8qdX/uGBGBW/N8V/D7
	3TnoEHZY3LKzf9nRLlVgemUpzkg01GIuKk4EAJGJq146AwAA
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
 drivers/video/backlight/lm3533_bl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 187d1c2..cff1fbe 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -296,11 +296,8 @@ static int lm3533_bl_probe(struct platform_device *pdev)
 	}
 
 	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
-	if (!bl) {
-		dev_err(&pdev->dev,
-				"failed to allocate memory for backlight\n");
+	if (!bl)
 		return -ENOMEM;
-	}
 
 	bl->lm3533 = lm3533;
 	bl->id = pdev->id;
-- 
1.7.10.4


