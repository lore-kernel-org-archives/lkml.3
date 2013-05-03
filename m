Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605Ab3ECGT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:19:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61199 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762195Ab3ECGT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:19:28 -0400
X-AuditID: cbfee68f-b7f066d000003683-fd-518356ef0dd6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/4] backlight: pcf50633: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:19:27 +0900
Message-id: <000e01ce47c6$29eb8280$7dc28780$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hxid3hTRkKmoQSRKVJBv4Llyi4A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zfd33Yc2BBj9uyVjMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBl3vnSy
	FDSxVzRtXM3SwPiLtYuRk0NCwERi78dZTBC2mMSFe+vZuhi5OIQEljFKfN61jxGmaMGrN0wQ
	iemMEk9//WWBcH4xSry/s4INpIpNQE3iy5fD7F2MHBwiAvoSbS0aIGFmgWKJ2WefgA0SFgiV
	OHtgLQuIzSKgKnH6zkmwVl4BS4mrn+ZC2YISPybfY4Ho1ZJYv/M4E4QtL7F5zVtmiIMUJHac
	fc0IsUpPYtY8V4gSEYl9L94xgpwmIbCJXeLomQlQuwQkvk0+xAJSLyEgK7HpANQYSYmDK26w
	TGAUm4Vk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MUKirH8H490D
	1ocYk4HWT2SWEk3OB0ZpXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoY2W9qzXkZe/yKsfHeXvPr8lsYrvWLfmxXcvEydShZOdlk3qVNXs8PFoVO
	fJR7pTVGstFUT+nR8SsV5R5FJ09FaKxYI/I71Y7r0/4/erwZ4V6Xvi19fMvTW2ZztTzjz08G
	Mx7n/1jGfNn5/lw9lsNaH1yyPzK57yvr1X4tlbpwk+nxikv6DgHflViKMxINtZiLihMBkIdM
	G8gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd33Yc2BBjdXS1rMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZd750shQ0sVc0bVzN0sD4i7WLkZNDQsBEYsGrN0wQtpjEhXvr
	2boYuTiEBKYzSjz99ZcFwvnFKPH+zgo2kCo2ATWJL18Os3cxcnCICOhLtLVogISZBYolZp99
	wghiCwuESpw9sJYFxGYRUJU4feckWCuvgKXE1U9zoWxBiR+T77FA9GpJrN95nAnClpfYvOYt
	M8RBChI7zr5mhFilJzFrnitEiYjEvhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgGH4mtYNxZYPFIUYBDkYlHl6FlqZAIdbEsuLK3EOMEhzMSiK8
	bj+AQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTC95JfGGxiZmRpZGZhZGJubmpAkrifMe
	aLUOFBJITyxJzU5NLUgtgtnCxMEp1cBY0pjLE9Wh8n1jqv7P0/t0Vx7aGnO+8AXHT7fDAVP2
	/ixXcv5bkdLsJr62UebmrtId88wSvu26vtlfTKD7onHfB2m1FyYPbr2OmM1p0ZhT8eq+qElW
	iHri9e5knoWi1w4u2u20aqJDYn1Tu2Rsn2XAxv+ukT/CfpdZz7coE951ZK5NV9BRfXYlluKM
	REMt5qLiRABgIK7YJQMAAA==
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
 drivers/video/backlight/pcf50633-backlight.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index e87c7a3..6ed76be 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -153,8 +153,6 @@ static int pcf50633_bl_remove(struct platform_device *pdev)
 
 	backlight_device_unregister(pcf_bl->bl);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


