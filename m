Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3CDIBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:01:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13529 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3CDIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:01:09 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-a5-513454c4ae37
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 09/24] rtc: rtc-generic: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:01:07 +0900
Message-id: <014201ce18ae$6d7874f0$48695ed0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAHqSA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA90jISaBBrO7BS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrgevmQt+sFc8aJnB0sD4nq2LkZNDQsBE4vj7N1C2mMSFe+vB
	bCGBZYwS01tLYGo+P25g6mLkAoovYpR4/uY9I4Qzm0li24Y1YB1sAmoSX74cZu9i5OAQEdCX
	aGvRAKlhFuhllDjTu5sdYqqtxJeHD5hAbE4BO4n751axgtjCAt4SC5qawOawCKhKzP3+AKye
	F6j+xOIfjBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4u+8yewQ
	JSIS+168A7tZQmAVu8SBps9MELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoRE1sQdjPcPWB9iTAZaP5FZSjQ5
	HxiZeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WGsfunzWkxOy/2SXTtJK+nWxaVGYSNrFj/WfU04F50UH/pK/vKT3s8nOZY1bWEvdNz55s+n4
	Cd14ob7zOcbcRZUxLyanGm54tTyh1a3i0X5XCUmO/Gvm+rwLEyZsY59UbpD2hiH46sY2N80U
	9R3G741UdgV/9Uwra/t0k/Vq4jYWP4ZdWxJ3KbEUZyQaajEXFScCAOiirvbCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO6REJNAg2MbeSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxq4Hr5kLfrBXPGiZwdLA
	+J6ti5GTQ0LAROLz4wYmCFtM4sK99UBxLg4hgUWMEs/fvGeEcGYzSWzbsAasg01ATeLLl8Ps
	XYwcHCIC+hJtLRogNcwCvYwSZ3p3s4PUCAnYSnx5+ABsKqeAncT9c6tYQWxhAW+JBU1NYHNY
	BFQl5n5/AFbPC1R/YvEPRghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg+yVEFCXePRXFyQs
	ImAk8XfeZHaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBkftMegfjqgaLQ4wCHIxKPLwCn4wDhVgTy4orcw8xSnAwK4nwlkmYBArxpiRW
	VqUW5ccXleakFh9iTAZ6dCKzlGhyPjCp5JXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpi
	SWp2ampBahHMFiYOTqkGxt6OPn6Lr5c+CSmsnfCg+ayAJJtH91qOlJmp+3dZ6W47O+VHZqSo
	icDrfW/uXnl9ZkGBXjvL54nvFRZ1hYft364zL/qkd/oFM0WFLPd+vwcnN2t0Bz1ftdZO7Nw1
	K0tvNp8rD1xnZhi+mfBjqzTn6m+3a5913DBIUmXbNG3fntPm9ke7Lxxq41diKc5INNRiLipO
	BAClQeBsIAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-generic.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-generic.c b/drivers/rtc/rtc-generic.c
index 98322004..0bf4530 100644
--- a/drivers/rtc/rtc-generic.c
+++ b/drivers/rtc/rtc-generic.c
@@ -65,18 +65,7 @@ static struct platform_driver generic_rtc_driver = {
 	.remove = __exit_p(generic_rtc_remove),
 };
 
-static int __init generic_rtc_init(void)
-{
-	return platform_driver_probe(&generic_rtc_driver, generic_rtc_probe);
-}
-
-static void __exit generic_rtc_fini(void)
-{
-	platform_driver_unregister(&generic_rtc_driver);
-}
-
-module_init(generic_rtc_init);
-module_exit(generic_rtc_fini);
+module_platform_driver_probe(generic_rtc_driver, generic_rtc_probe);
 
 MODULE_AUTHOR("Kyle McMartin <kyle@mcmartin.ca>");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


