Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726Ab3ECGaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:30:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21491 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633Ab3ECG36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:29:58 -0400
X-AuditID: cbfee690-b7f136d000000fea-99-51835965a20a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 15/42] rtc: rtc-dm355evm: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:29:57 +0900
Message-id: <001d01ce47c7$a189a6e0$e49cf4a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx58fByGCvBQaQv+68KCUCjVMkw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ93UyOZAgwu/5C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuL/hK3PBDraKPSu7WBsY17N2MXJySAiYSEz70M4MYYtJXLi3nq2LkYtDSGAZo0TP
	6VNMMEVN3Z+gEtMZJaauvA+WEBL4xSjR1ZQJYrMJqEl8+XKYvYuRg0NEQF+irUUDpJ5ZoJtR
	4lHzXLANwgKhEs2rTzGC2CwCqhIPJ00Bu4JXwFLiyvE3TBC2oMSPyfdYQGxmAS2J9TuPM0HY
	8hKb17yFulRBYsfZ12BzRAT0JLYufMAKUSMise/FO0aQxRICx9glOrbehFomIPFt8iEWkOMk
	BGQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRiV5xYm5xaV66
	XnJ+7iZGSOxN2MF474D1IcZkoPUTmaVEk/OBsZtXEm9obGZkYWpiamxkbmlGmrCSOK96i3Wg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbKNU+uLp9Y+/Gd2czLsiYX/nn5hD4/vNhVoVPp
	6Q7NNyursh8l3S4ILs968HCCYZaNC/f1tg/uLgHvqzs/mGs859+vKvF617MJC7eEL/b4I7np
	UcNutze/mDccTD358dW5K8YPUt9WPty4Rrm0LsR4f/mdlI5cj90r7OS9knO3HQr2lX5wojNV
	iaU4I9FQi7moOBEAitmU1dMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd3UyOZAg6atMhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZtzf8JW5YAdbxZ6VXawNjOtZuxg5OSQETCSa
	uj+xQdhiEhfurQeyuTiEBKYzSkxdeZ8JJCEk8ItRoqspE8RmE1CT+PLlMHsXIweHiIC+RFuL
	Bkg9s0A3o8Sj5rnMIDXCAqESzatPMYLYLAKqEg8nTQFbxitgKXHl+BsmCFtQ4sfkeywgNrOA
	lsT6nceZIGx5ic1r3jJDHKQgsePsa7A5IgJ6ElsXPmCFqBGR2PfiHeMERoFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNnPpHYwrmywOMQowMGoxMOr0NIU
	KMSaWFZcmXuIUYKDWUmE1+0HUIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgUknryTe0NjE
	zMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY41ZfsbqYZr5iQ7OGon5M
	5BrpzDm/by24+13ylk7l2+3/y+snznJ8WVrLOu+Kzr6LdyUEDy2Uj74gFNh33exSTpvXl0X3
	P5W0W1gwnj+/iF03Mtbv7lZJrl3CFbVNf3Un9M5Scbjz82cXV1213WLWrdtWXjbnXSVrWs6b
	mxwxkdOeu/NvzKQYJZbijERDLeai4kQAxmto7jADAAA=
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
 drivers/rtc/rtc-dm355evm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index 1e1ca63..1855581 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -141,7 +141,6 @@ static int dm355evm_rtc_probe(struct platform_device *pdev)
 
 static int dm355evm_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


