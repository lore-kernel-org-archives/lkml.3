Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3BDAOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 19:14:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49909 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab3BDAOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 19:14:07 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-98-510efd4c0af7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'G.Shark Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: lm3630: remove ret = -EIO of
 lm3630_backlight_register()
Date: Mon, 04 Feb 2013 09:14:04 +0900
Message-id: <00b801ce026c$8a90ec00$9fb2c400$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4CbIo7He5bJ1IdRoiR6Vr3GNFubQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ12fv3yBBn9v6ltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MvffXshd84aj41t/L3sC4hL2LkZNDQsBEYuX7flYIW0ziwr31
	bF2MXBxCAssYJeafu8MMU7TnyHuoxCJGid7uPewQzmwmiVXrlrCAVLEJqEl8+XIYbKyIQIRE
	84xZYN3MAlUSi6beBFrBwSEsECbx42wISJhFQFXiyvOHYOW8ArYSyyfdZ4OwBSV+TL7HAtGq
	JbF+53EmCFteYvOat8wgYyQE1CUe/dUFMUUE9CT2Hg2DqBCR2PfiHSPIZRIC7ewSW14cYYNY
	JSDxbfIhFohWWYlNB6DekpQ4uOIGywRGsVlIFs9CsngWksWzkKxYwMiyilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyMkTqR3MK5qsDjEKMDBqMTDy/CLL1CINbGsuDL3EKMEB7OSCO9VI6AQ
	b0piZVVqUX58UWlOavEhxmSgYycyS4km5wNjOK8k3tDY2MTMxNTE3NLU3JQ0YSVxXsZTTwKE
	BNITS1KzU1MLUotgtjBxcEo1MGq0em1vli6J+TclTpGhb4nTGfFjP2bnbDppzfXx7I+MxLK1
	8xc/3J0S0aoQEbZjB6OhktKq/TceRwt5cWx/JbG09XpFlvLkiNbNqwSY/mtWfJi7eOGduBnr
	f6/bc5TD1sf0W+rBL02r+rZztjew6E2Kmme9umNPdarJi1aTS4zmLxpLLyv+naXEUpyRaKjF
	XFScCAAmQ+rR1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAV2fv3yBBhc2aVpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjL3317IXfOGo+Nbfy97A
	uIS9i5GTQ0LARGLPkfdsELaYxIV764FsLg4hgUWMEr3de9ghnNlMEqvWLWEBqWITUJP48uUw
	WLeIQIRE84xZzCA2s0CVxKKpN1m7GDk4hAXCJH6cDQEJswioSlx5/hCsnFfAVmL5pPtsELag
	xI/J91ggWrUk1u88zgRhy0tsXvOWGWSMhIC6xKO/uiCmiICexN6jYRAVIhL7XrxjnMAoMAvJ
	oFlIBs1CMmgWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj8Jn0DsZVDRaHGAU4
	GJV4eBl+8QUKsSaWFVfmHmKU4GBWEuG9agQU4k1JrKxKLcqPLyrNSS0+xJgM9OdEZinR5Hxg
	gsgriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYyie3d/D5kx
	9SB7WE66nxHH9l1yIh+Wyt64I73/eWy3p+eTw6zfZkvGGUSnFRx6PWe1iOuy+0kSq3nVTYtX
	dB85KXqIMcGR+aeqoszVI53sNpOmTlvdGj8zScJpneS5DJajnifSEg9NmKl8In+HpFb6nTST
	PBaRz4/Xbu+REGS+oNBUFxi1+4ESS3FGoqEWc1FxIgBLNJFhBgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to return -EIO, because backlight_device_register()
already returns correct error values.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3630_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lm3630_bl.c b/drivers/video/backlight/lm3630_bl.c
index a6d637b..76a62e9 100644
--- a/drivers/video/backlight/lm3630_bl.c
+++ b/drivers/video/backlight/lm3630_bl.c
@@ -320,7 +320,7 @@ static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
 		    backlight_device_register(name, pchip->dev, pchip,
 					      &lm3630_bank_a_ops, &props);
 		if (IS_ERR(pchip->bled1))
-			return -EIO;
+			return PTR_ERR(pchip->bled1);
 		break;
 	case BLED_2:
 		props.brightness = pdata->init_brt_led2;
@@ -329,7 +329,7 @@ static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
 		    backlight_device_register(name, pchip->dev, pchip,
 					      &lm3630_bank_b_ops, &props);
 		if (IS_ERR(pchip->bled2))
-			return -EIO;
+			return PTR_ERR(pchip->bled2);
 		break;
 	}
 	return 0;
-- 
1.7.2.5


