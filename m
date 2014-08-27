Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaH0BLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:11:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23224 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaH0BLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:11:16 -0400
X-AuditID: cbfee68e-f79536d000000fd1-b6-53fd3032638f
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 06/18] backlight: cr_bllcd: add blank line after declarations
Date: Wed, 27 Aug 2014 10:11:14 +0900
Message-id: <004a01cfc193$cc247b90$646d72b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAFh/g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY10jg7/BBgc+WFoc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmf53az
	FLxiq9h+lb2B8TNrFyMnh4SAicSZ1qNQtpjEhXvr2UBsIYFljBJLt5bB1Gw99paxi5ELKD6d
	UWL65vvMEM5vRon1S2+CdbMJqEl8+XKYHcQWEVCQ2Nz7DCzOLJAr8XvmSkaIqbYSlxeuZQKx
	OQXsJGZ/mA5WLywQIHH871+wehYBVYk/E1eB2bxA9Z/uH2OCsAUlfky+xwIxU0ti/c7jTBC2
	vMTmNW+BDuIAulRd4tFfXRBTRMBI4sZxbogKEYl9L96B3S8hcIxdomf/DahVAhLfJh9igWiV
	ldh0gBniX0mJgytusExglJiFZPEsJItnIVk8C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1
	kvNzNzFCIrJvB+PNA9aHGAU4GJV4eD8s+BMsxJpYVlyZe4jRFOiiicxSosn5wLjPK4k3NDYz
	sjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMalzo3T+tp0e+6Yb
	z2HIFrxnUHhR/YpB+gGLp0EfpdTsH69k2qZUzDrp8+eNmc7/9/pEqeq9KdQWc905Ufnn8rdV
	ftvvzmyvTWuWiFtelnK7wnDbU7NX+jlrXptxdBlflRYQd/a5su2MjRfjg6uHVOME6o5+FS5m
	TylsLCh4tGRSguXj732PlFiKMxINtZiLihMB3uinTMMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV0jg7/BBpPmmFkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZn+d2sxS8YqvYfpW9gfEzaxcjJ4eEgInE1mNvGSFsMYkL99az
	dTFycQgJTGeUmL75PjOE85tRYv3Sm2AdbAJqEl++HGYHsUUEFCQ29z4DizML5Er8nrkSbJKQ
	gK3E5YVrmUBsTgE7idkfpoPVCwsESBz/+xesnkVAVeLPxFVgNi9Q/af7x5ggbEGJH5PvsUDM
	1JJYv/M4E4QtL7F5zVuggziALlWXePRXF8QUETCSuHGcG6JCRGLfi3eMExiFZiEZNAvJoFlI
	Bs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEP5PewbiqweIQowAHoxIP74cF
	f4KFWBPLiitzDzFKcDArifAmK/wNFuJNSaysSi3Kjy8qzUktPsRoCvTnRGYp0eR8YDLKK4k3
	NDYxM7I0MrMwMjE3VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAuHX7vYT+vka5rc/T9tab
	fnTZdusOm7CT/XfmvS8VoyfOX+ircDN6q1aUefKVdQpdKs1zVfIDj19pPr73p/eW0IrwmXZK
	MgInXrOpeQX6FC2Vyj1Qydd6uV1vZrJJNFf01lZuluKbvbGnrFedq1y9d47QyRvub98c13u3
	IDjBzDh8e+wi3ZeSSizFGYmGWsxFxYkAXtEpjw4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/cr_bllcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index f3fed9ef745f..3e3880fc8c8e 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -235,6 +235,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 static int cr_backlight_remove(struct platform_device *pdev)
 {
 	struct cr_panel *crp = platform_get_drvdata(pdev);
+
 	crp->cr_backlight_device->props.power = FB_BLANK_POWERDOWN;
 	crp->cr_backlight_device->props.brightness = 0;
 	crp->cr_backlight_device->props.max_brightness = 0;
-- 
2.0.0


