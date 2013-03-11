Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3CKJjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:39:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41405 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3CKJjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:39:13 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-bb-513da640e79e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c901ce1e3c$26d976a0$748c63e0$%han@samsung.com>
In-reply-to: <00c901ce1e3c$26d976a0$748c63e0$%han@samsung.com>
Subject: [PATCH 2/3] backlight: omap1: use dev_info() instead of pr_info()
Date: Mon, 11 Mar 2013 18:39:11 +0900
Message-id: <00ca01ce1e3c$494f06f0$dbed14d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ePCa8v3pUfLowT1qxE3rZdWcGSgAABd8w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA12HZbaBBofXClnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkr5m5g
	K9jBXjF9lkYD42y2LkZODgkBE4m3r6cxQdhiEhfurQeKc3EICSxjlGhr6YcrejGrjxkiMZ1R
	4vm+bVDOL0aJeZcvsYNUsQmoSXz5chjI5uAQEdAH6tYACTMLlEpsffCeBcQWErCVOD/xHTOI
	zSlgJ/HxzyGwcmEBL4n185xAwiwCqhKnrp4G28sLVP73yVZmCFtQ4sfkeywQI7UkNm9rYoWw
	5SU2r3nLDDJGQkBd4tFfXZCwiICRxP7HT5kgSkQk9r14xwhysYTAOXaJzX3LWSB2CUh8m3yI
	BaJXVmLTAWaIdyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1StOzC0u
	zUvXS87P3cQIiciJOxjvH7A+xJgMtH4is5Rocj4wovNK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwCjZOlnCYruO5unoctd8FYcPX2Na2U5Xveb/
	5Z5TtO2bUEsy++/YX77bX7J8tHry7/95g1n7ft1Y3FycmDIz6uf5VL2UdQy291guGUxKmRof
	cu/AP6Oa2EyLuUavjkXdYv/cb7D67/IXFYKPSo0ZVxy/Mc0jX0dG4DPbrIl3/c/v49BQsP4y
	6a8SS3FGoqEWc1FxIgC4y//z3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV2HZbaBBksO8VnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZK+ZuYCvYwV4xfZZGA+Nsti5GTg4JAROJF7P6mCFsMYkL99YD
	xbk4hASmM0o837eNGcL5xSgx7/IldpAqNgE1iS9fDgPZHBwiAvoSbS0aIGFmgVKJrQ/es4DY
	QgK2EucnvgMbyilgJ/HxzyGwcmEBL4n185xAwiwCqhKnrp4Gu4EXqPzvk63MELagxI/J91gg
	RmpJbN7WxAphy0tsXvOWGWSMhIC6xKO/uiBhEQEjif2PnzJBlIhI7HvxjnECo9AsJJNmIZk0
	C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvdn0jsYVzVYHGIU4GBU4uGd
	oGMbKMSaWFZcmXuIUYKDWUmEd+Umm0Ah3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemoryS
	eENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYAya5X80hGtqsMUe
	mf8h3Oc/THvGlqAmftfp1iyBPUvnPNKZviTo2++LOZ4dQnrvrPef0VOc8vvf+80WN3YfyQk5
	MPWl4VO1mev3xe/Ql/sikPX6Zb5NaP3tl16+E7+8fLttx1JWsaQpL4/r7rn9OnmFd4J5YrLZ
	xstWRreu73UUOfVau39l229uJZbijERDLeai4kQArYQkTDsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_info() is more preferred than pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/omap1_bl.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 6271101..0aed176 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -18,8 +18,6 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -170,7 +168,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	dev->props.brightness = pdata->default_intensity;
 	omapbl_update_status(dev);
 
-	pr_info("OMAP LCD backlight initialised\n");
+	dev_info(&pdev->dev, "OMAP LCD backlight initialised\n");
 
 	return 0;
 }
-- 
1.7.2.5


