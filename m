Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817Ab3ECGcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:32:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63715 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762722Ab3ECGcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:32:14 -0400
X-AuditID: cbfee68d-b7f016d000007930-09-518359ec8793
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 23/42] rtc: rtc-max8925: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:32:12 +0900
Message-id: <002501ce47c7$f1f8ee10$d5eaca30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx/E1OkBbDWyaRZuRLKPnTZUB0A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zA903kc2BBv39ehZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBldO74z1zwmbOi+fRHtgbGdo4uRk4OCQETidMnt7FB2GISF+6tB7K5OIQEljFK9DQ+
	ZYEpmvb9BStEYjqjxIL9X1ggnF+MEp/nX2MHqWITUJP48uUwkM3BISKgL9HWogFSwyzQzSjx
	qHkuM0iNsECIxL0lZ8GmsgioSuxesYEJxOYVsJSYtGYxI4QtKPFj8j2wGmYBLYn1O48zQdjy
	EpvXvGWGuEhBYsfZ12D1IgJ6Ets3rYeqEZHY9+IdI8hiCYFj7BLnz5xkhFgmIPFt8iEWkOMk
	BGQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRoV5xYm5xaV66
	XnJ+7iZGSPT17mC8fcD6EGMy0PqJzFKiyfnA6M0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQ
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2OqaFiehPbOzJopG7KbFs64nStZ6mtUv+S73e2g
	dzNmq67bejZlRv020/0yC2fuDPRi3p92Yq1vdpORgujXbZ2zjdZW/716MdD+5NTZp9fu9dh0
	TZplsesdzdqbzv+UrWedvmGmpLz306tE3wU7Tp6Qyk2yln64fO2jXPNUtnkfnnBNCKot7JVW
	YinOSDTUYi4qTgQAuqQKCtQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd03kc2BBleWaFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNG54z9zwWfOiubTH9kaGNs5uhg5OSQETCSm
	fX/BCmGLSVy4t56ti5GLQ0hgOqPEgv1fWCCcX4wSn+dfYwepYhNQk/jy5TCQzcEhIqAv0dai
	AVLDLNDNKPGoeS4zSI2wQIjEvSVnWUBsFgFVid0rNjCB2LwClhKT1ixmhLAFJX5MvgdWwyyg
	JbF+53EmCFteYvOat8wQFylI7Dj7GqxeREBPYvum9VA1IhL7XrxjnMAoMAvJqFlIRs1CMmoW
	kpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj+5n0DsZVDRaHGAU4GJV4eBVamgKF
	WBPLiitzDzFKcDArifC6/QAK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w7eSVxBsam5gZ
	WRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2P1ym2bbjS+TPpnsOK579O3
	00uX8lz8f8TGSeidzH/1q28Wruw/8m1SMk/TDCnnVwKtHTemTdnz2fPb57pIO+6uL7sKHlr7
	s5Y7FUVoPG/XO1ZU8UbR7tz6o5fPSPhx3OG14V5XMulK/tFvJy5pmlw3aBRg6llcws/2bPv1
	qNgoafNdbovcV7xRYinOSDTUYi4qTgQAlUlSFTEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max8925.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 7c90f4e..981b654 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -268,7 +268,7 @@ static int max8925_rtc_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
 			info->irq, ret);
-		goto err;
+		return ret;
 	}
 
 	dev_set_drvdata(&pdev->dev, info);
@@ -282,13 +282,10 @@ static int max8925_rtc_probe(struct platform_device *pdev)
 	ret = PTR_ERR(info->rtc_dev);
 	if (IS_ERR(info->rtc_dev)) {
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	return 0;
-err:
-	platform_set_drvdata(pdev, NULL);
-	return ret;
 }
 
 static int max8925_rtc_remove(struct platform_device *pdev)
-- 
1.7.2.5


