Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab3ECGkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:40:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62122 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3ECGkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:40:19 -0400
X-AuditID: cbfee68d-b7f016d000007930-f8-51835bd23201
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 42/42] rtc: rtc-tile: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:40:18 +0900
Message-id: <003801ce47c9$13d6dcd0$3b849670$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyRMD54UhljaZSympPCHI2NrS9g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY91L0c2BBhNeGlksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMfXjeuaCeWwVty8tZ2xgnMTaxcjJISFgIvFy2RImCFtM4sK99WwgtpDAMkaJSfMt
	YWq+vJzC2MXIBRRfxChxbfI7JgjnF6PEpl+rwLrZBNQkvnw5zN7FyMEhIqAv0daiAVLDLNDN
	KPGoeS4zSI2wgL/EoYOHwTazCKhKXNnRwQJi8wpYSrx80M4KYQtK/Jh8DyzOLKAlsX7ncSYI
	W15i85q3zBAXKUjsOPuaEcQWEdCTuH72MFS9iMS+F+/ALpUQOMYu0TD1KTPEMgGJb5MPsYAc
	JyEgK7HpANQcSYmDK26wTGAUm4Vk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz
	0vWS83M3MUJir3cH4+0D1ocYk4HWT2SWEk3OB8ZuXkm8obGZkYWpiamxkbmlGWnCSuK8ai3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYFe//PrdMaXHyvjbRv6ov9gbefXhWx9iPz61S
	6qbt3A0r7U49/dJ7fHeeYWJG37eV5icfx9ss8Vj7b7mB+wSvSZPWt1saiTiFMbNZhrJvyZtj
	yB/1ZuuqAtfGrkdCfyWsmZL9Gc6o+2zP4/UKWc6eNmcu28czP9Yd2eVUIMJYlf/Y9tqKcw+b
	lViKMxINtZiLihMBPBoKk9MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd1L0c2BBjOO61ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDH143rmgnlsFbcvLWdsYJzE2sXIySEhYCLx
	5eUURghbTOLCvfVsXYxcHEICixglrk1+xwTh/GKU2PRrFRNIFZuAmsSXL4fZuxg5OEQE9CXa
	WjRAapgFuhklHjXPZQapERbwlzh08DDYBhYBVYkrOzpYQGxeAUuJlw/aWSFsQYkfk++BxZkF
	tCTW7zzOBGHLS2xe85YZ4iIFiR1nX4NdJyKgJ3H97GGoehGJfS/eMU5gFJiFZNQsJKNmIRk1
	C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBsf1MegfjqgaLQ4wCHIxKPLwKLU2B
	QqyJZcWVuYcYJTiYlUR43X4AhXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmHbySuINjU3M
	jCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHRXzaqf4Wea1L6zemcFirn
	DBOfRp8O4PO7/WvRua5/1sJ6BV83XX36RLl3qdBE6U3hin8sN3a5c34O27Xv85XTXleE/Z7s
	vO228bFWSPhs9pnvDx/ZvKl0Y2q1gQKjcHzq87inE5ZEL+S1mXA2+6f4dulMZvNFbrriIuu0
	si+sPLi+8v2cyHnPlFiKMxINtZiLihMBiJzj4zEDAAA=
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
 drivers/rtc/rtc-tile.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-tile.c b/drivers/rtc/rtc-tile.c
index 249b653..add4a7e 100644
--- a/drivers/rtc/rtc-tile.c
+++ b/drivers/rtc/rtc-tile.c
@@ -96,8 +96,6 @@ static int tile_rtc_probe(struct platform_device *dev)
  */
 static int tile_rtc_remove(struct platform_device *dev)
 {
-	platform_set_drvdata(dev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


