Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaEGIXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:23:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62206 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbaEGIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:23:17 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-ad-5369ed745ffd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mike Rapoport'" <mike.rapoport@ravellosystems.com>
References: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
In-reply-to: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
Subject: [PATCH 3/4] mfd: tps6586x: Make of_device_id array const
Date: Wed, 07 May 2014 17:23:15 +0900
Message-id: <01f601cf69cd$981f3d30$c85db790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzI23B3Krz2pOTtOM+cSg7C0yRwAAO+hg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI92St5nBBrfuslhcXniJ1eL+16OM
	Fpd3zWGzWPOsncXidDerA6vHnWt72DzmnQz02HfwEbNH35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZSw92sVcsJy14vnux6wNjOtZuhg5OCQETCQa1kZ3MXICmWISF+6tZ+ti5OIQEljGKNH6
	bjUrRMJE4v+2f4wQiUWMEieudEI5vxkl9n1fxQRSxSagJvHly2F2EFsEyL65ZxYTSBGzwBJG
	iaW3PoONEhKwlTi0/hkTyGpOATuJ57uDQMLCAo4SP7vmsoDYLAKqEmuWHgWzeYHKp534ywZh
	C0r8mHwPLM4soCWxfudxJghbXmLzmrfMEN+oSzz6qwtxgpHEyu1bocpFJPa9eAd2s4TALXaJ
	f+d/s0HsEpD4NvkQNCRkJTYdYIZ4WFLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILk
	guKk9CIjveLE3OLSvHS95PzcTYyQKO3bwXjzgPUhxmSg9ROZpUST84FRnlcSb2hsZmRhamJq
	bGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOd5eq01XDqpveVKUIj8
	d8m32y7aTomMe9/6dpV/5fZFwtW6dwKWBcuX6OdnGnTGV57wt2JJYJl09pTj58usnM06ppNW
	XbEUKzii/tOs12N3FsesKV/Y4wzU+da6rmeZceL4jFuvUydLiCi+SuAt7dFmytRbvPq0/pl7
	ywsWO6VGCafaJghEKbEUZyQaajEXFScCANBOhf3oAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd2St5nBBo1NjBaXF15itbj/9SiQ
	tWsOm8WaZ+0sFqe7WR1YPe5c28PmMe9koMe+g4+YPfq2rGL0+LxJLoA1qoHRJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdot5JCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+nRLuaC5awVz3c/Zm1gXM/SxcjJISFgIvF/2z9G
	CFtM4sK99WxdjFwcQgKLGCVOXOlkhHB+M0rs+76KCaSKTUBN4suXw+wgtgiQfXPPLCaQImaB
	JYwSS299ZgVJCAnYShxa/wwowcHBKWAn8Xx3EEhYWMBR4mfXXLDNLAKqEmuWHgWzeYHKp534
	ywZhC0r8mHwPLM4soCWxfudxJghbXmLzmrfMICMlBNQlHv3VhTjBSGLl9q1Q5SIS+168Y5zA
	KDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCk8Az6R2Mqxos
	DjEKcDAq8fBavM0IFmJNLCuuzD3EKMHBrCTCu+tiZrAQb0piZVVqUX58UWlOavEhxmSgRycy
	S4km5wMTVF5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MEpc
	TM4WeD6BZ6/+tO6F876s6X7G8Gn/2yUruO/6T7rxd4rYMhfZLjeD2J/aztnZUiZ6/oclP0xe
	2roi9OeLOcnC9xWtTp3kyVo3Nb7L4BjDpwyDIOPwHSY73q/W/P9235LJGRNClmZ4uixovv1I
	0GIGy7SSTfHTQrY/kDwl/fVmW/LmO4fEJ29TYinOSDTUYi4qTgQAvOitl0YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/tps6586x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index bbd5441..ccd7082 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -444,7 +444,7 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 	return pdata;
 }
 
-static struct of_device_id tps6586x_of_match[] = {
+static const struct of_device_id tps6586x_of_match[] = {
 	{ .compatible = "ti,tps6586x", },
 	{ },
 };
-- 
1.7.10.4


