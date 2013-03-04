Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3CDH7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:59:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31837 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3CDH7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:59:49 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-55-513454742a40
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 06/24] rtc: rtc-davinci: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:59:47 +0900
Message-id: <013f01ce18ae$3dbff710$b93fe530$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAExwg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ92SEJNAg3NHuSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOPjyOWvBY/aKj2tXsDYw3mLrYuTkkBAwkdj97ysrhC0mceHeeqA4F4eQwDJGiaZp
	L9hhil7uvs8MYgsJTGeUuPnZEKLoF6PE7bPTwBJsAmoSX74cBmrg4BAR0Jdoa9EAqWEW6GWU
	ONO7mx2i2Vbiy8MHTCA2p4CdxP1zq8A2Cwt4S3RO+wRmswioSjTfbga7jheovu3YSnYIW1Di
	x+R7LCA2s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJHFo1ndWiBIRiX0v3jGC3CMh
	cI9d4vKVdkaIXQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsY
	RVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQiK1bwfjzQPWhxiTgdZPZJYSTc4HRnpeSbyhsbGJ
	mYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDaqQaIesv1eDLx
	9R5+3VhXcXxprIzA88OnLdIevvjiU8g8IeKSfdT8O5yXH0tNa61XT/wsunX6AatjS0/GXhIP
	TdyeejNnX4zU+qWi/69qnF4klep0w7yVzfuL7zu9ie55UU9L//4IdVir1GhZ9++wzSzW0JsN
	nLustztVBVof7jk6c4lwY6USS3FGoqEWc1FxIgAwW4yQ6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2SEJNAg51NbBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZhx8+Zy14DF7xce1K1gbGG+xdTFyckgImEi8
	3H2fGcIWk7hwbz1YXEhgOqPEzc+GXYxcQPYvRonbZ6eBFbEJqEl8+XKYvYuRg0NEQF+irUUD
	pIZZoJdR4kzvbnaIZluJLw8fMIHYnAJ2EvfPrWIFsYUFvCU6p30Cs1kEVCWabzeDLeMFqm87
	tpIdwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEkcmvWdFaJERGLf
	i3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAaeCa1
	g3Flg8UhRgEORiUeXoFPxoFCrIllxZW5hxglOJiVRHjLJEwChXhTEiurUovy44tKc1KLDzEm
	Az06kVlKNDkfmKLySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwen
	VAMjg3HgF92eutnXS49Hbpn9QmpeJY/4sb+uN/2WJV+wfezYqOQXLKt/ZPOqFdsfPfn071v6
	3QbRiUWyu9ZuPJ4umeg0x0bsRM/RTbdM8l3vdKTNevLygGLWVO/7b7xjElTU7aLOPngzX0Jz
	4/mME0pnNpj6P3hv+EE9+NQsl3o3/xuvDp86KOtfq8RSnJFoqMVcVJwIAFIzagpHAwAA
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
 drivers/rtc/rtc-davinci.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index db877e0..1b0f9322 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -588,17 +588,7 @@ static struct platform_driver davinci_rtc_driver = {
 	},
 };
 
-static int __init rtc_init(void)
-{
-	return platform_driver_probe(&davinci_rtc_driver, davinci_rtc_probe);
-}
-module_init(rtc_init);
-
-static void __exit rtc_exit(void)
-{
-	platform_driver_unregister(&davinci_rtc_driver);
-}
-module_exit(rtc_exit);
+module_platform_driver_probe(davinci_rtc_driver, davinci_rtc_probe);
 
 MODULE_AUTHOR("Miguel Aguilar <miguel.aguilar@ridgerun.com>");
 MODULE_DESCRIPTION("Texas Instruments DaVinci PRTC Driver");
-- 
1.7.2.5


