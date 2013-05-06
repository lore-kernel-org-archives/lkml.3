Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3EFEGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:06:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42068 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3EFEGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:06:33 -0400
X-AuditID: cbfee691-b7fe56d000004b96-9b-51872c480651
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Peter Ujfalusi'" <peter.ujfalusi@ti.com>
Subject: [PATCH 3/8] mfd: twl4030-audio: remove unnecessary
 platform_set_drvdata()
Date: Mon, 06 May 2013 13:06:31 +0900
Message-id: <003001ce4a0f$1771ec70$4655c550$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KDwE+PfMUFsFkRBuYxbg/+ATdnQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfV0PnfZAg7NXhS0uL7zEanF51xw2
	i1kff7BanO5mdWDxmHcy0KNvyypGj+M3tjN5fN4kF8ASxWWTkpqTWZZapG+XwJXx6+9r1oLH
	HBXHr8xib2Cczd7FyMkhIWAicXX7bxYIW0ziwr31bF2MXBxCAssYJb519sIV/V/RCZVYxCjx
	/lEvK4Tzi1Hi65GdbCBVbAJqEl++HAbrEBHQkug+dh4sziyQJ7F66iymLkYODmGBEIlrawJA
	wiwCqhIrf94D28wrYCmx4dcbKFtQ4sdkiDgz0Jj1O48zQdjyEpvXvGWGOEhBYsfZ14wQq/Qk
	jq1rZYeoEZHY9+IdI8htEgKr2CUentrNDrFMQOLb5EMsIDdICMhKbDoANUdS4uCKGywTGMVm
	IVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkBibuIPx/gHrQ4zJ
	QOsnMkuJJucDYzSvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwLkwytOLl8Vz9gs6p613n/4BefD6EZTLyK+vrr1mpv5HzTYFj8Ysbt2Uu1vTOF
	GdKsTlSevx68guPFrrMJe0Qi5jr1PbpQmLeHhXnlV8GghkldsydUWh6Sea3Hy3HhCvs6szlC
	JTpunGG/lBXPhV+uN66tdfwl+u7xu8T8+dXCzD+9zKoT3iuxFGckGmoxFxUnAgABPPq3xwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV0PnfZAg8aJAhaXF15itbi8aw6b
	xayPP1gtTnezOrB4zDsZ6NG3ZRWjx/Eb25k8Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPM+PX3NWvBY46K41dmsTcwzmbvYuTkkBAwkfi/opMNwhaTuHBvPZDN
	xSEksIhR4v2jXlYI5xejxNcjO8Gq2ATUJL58OQzWLSKgJdF97DxYnFkgT2L11FlMXYwcHMIC
	IRLX1gSAhFkEVCVW/rzHAmLzClhKbPj1BsoWlPgxGSLODDRm/c7jTBC2vMTmNW+ZIQ5SkNhx
	9jUjxCo9iWPrWtkhakQk9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIER/Az6R2MqxosDjEKcDAq8fAWPGkLFGJNLCuuzD3EKMHBrCTC67MXKMSb
	klhZlVqUH19UmpNafIgxGejTicxSosn5wOSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MQZyO5mlHGAVn5Cuf31ocd+6+RUGHybwcpdyM8ut8aeU7au0S
	G48xPut67VQqXeVl4Tw/5k5DS/a5SH6ZBIUdJx/OmndkdsWHhFU1r4tCtvKYRqz/VznrD0ej
	pPasUrbupe8Zkp/f2a01u34Td+LiDCYj9+MbimNeSL01CxE8enavS0Y4m4gSS3FGoqEWc1Fx
	IgDIdEp3JAMAAA==
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
 drivers/mfd/twl4030-audio.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index d2ab222..a31fba9 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -261,10 +261,8 @@ static int twl4030_audio_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 	}
 
-	if (ret) {
-		platform_set_drvdata(pdev, NULL);
+	if (ret)
 		twl4030_audio_dev = NULL;
-	}
 
 	return ret;
 }
@@ -272,7 +270,6 @@ static int twl4030_audio_probe(struct platform_device *pdev)
 static int twl4030_audio_remove(struct platform_device *pdev)
 {
 	mfd_remove_devices(&pdev->dev);
-	platform_set_drvdata(pdev, NULL);
 	twl4030_audio_dev = NULL;
 
 	return 0;
-- 
1.7.2.5


