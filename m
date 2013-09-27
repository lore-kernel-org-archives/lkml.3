Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3I0D7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:59:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21913 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3I0D7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:59:30 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-5a-524502a03499
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>
Subject: [PATCH] MAINTAINERS: remove Richard Purdie as backlight maintainer
Date: Fri, 27 Sep 2013 12:59:28 +0900
Message-id: <017f01cebb35$f6a82ac0$e3f88040$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac67NfaIhScX41ewQ52lLWIDp/WMEw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zA90FTK5BBt+v2ljMWb+GzWLy7i5W
	i8sLL7FaTGy6w2Jxou8DkLtrDpvFhMOb2S2W/1rHYrF711NWi5+75rFYrJ9/i82B2+PVVUeP
	nbPusnvM7pjJ6nFixm8Wjz3zf7B69G1Zxehx/MZ2Jo/Pm+QCOKK4bFJSczLLUov07RK4Mu7u
	a2IteMpScXjfStYGxm/MXYycHBICJhJ/ny1ig7DFJC7cWw9kc3EICSxjlJj9voEdpujg0h9g
	RUICixgljp0OhCj6xSjRfuMIC0iCTUBN4suXw0ANHBwiAvoSbS0aIDXMAkuZJRbN2g9WIyzg
	LTFrTzPYZhYBVYnuY61gNq+ArcTds7OZIGxBiR+T74HVMwtoSazfeZwJwpaX2LzmLTPIfAkB
	dYlHf3VBwiICehKHdnSzQpSISOx78Y4RZK+EQCuHxI1vnxkhdglIfJt8iAWiV1Zi0wGo5yUl
	Dq64wTKBUWwWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIiegJ
	OxjvHbA+xJgMtH4is5Rocj4wIeSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgdHTb1IfT8YChYntXu4rm/ZpSXALTX30Z7n/fsn5Jgkmh2Vutj/u
	fVWXvbCx7+W7/cYz1kjI2x4SMeVWtnnxlq9qzt80lp1qOkVXAot6Y2UdlvHlHtlerybikZ/+
	wE6lUWvWP7OXsVMaHi3V+cfKfKp8mdjkrpZcprRfM5ibQpemNj0uk+beq8RSnJFoqMVcVJwI
	ABkzcC/+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd0FTK5BBnu7LCzmrF/DZjF5dxer
	xeWFl1gtJjbdYbE40fcByN01h81iwuHN7BbLf61jsdi96ymrxc9d81gs1s+/xebA7fHqqqPH
	zll32T1md8xk9Tgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QJcqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwnrGDPu7mtiLXjKUnF430rWBsZvzF2MnBwSAiYSB5f+YIOwxSQu
	3FsPZgsJLGKUOHY6sIuRC8j+xSjRfuMIC0iCTUBN4suXw+xdjBwcIgL6Em0tGiA1zAJLmSUW
	zdoPViMs4C0xa08z2AIWAVWJ7mOtYDavgK3E3bOzmSBsQYkfk++B1TMLaEms33mcCcKWl9i8
	5i0zyHwJAXWJR391QcIiAnoSh3Z0s0KUiEjse/GOcQKjwCwkk2YhmTQLyaRZSFoWMLKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAhOF8+kdjCubLA4xCjAwajEwyuQ4RIkxJpYVlyZe4hR
	goNZSYR3fSxQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBqSyvJN7Q2MTMyNLIzMLIxNyc
	NGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhiL2Pfpqv/fv+PZ9odL1xc4Gxvd8eGILnL3
	0q5OmNa7dB+TUBJ/8yLBxqqi7p6tMguf/VvIcUGqqESg0FzpfWzP6mcs01lNT22N4W3fPHV6
	9iKmzM/bDDrmbjxT6px3+93JUt5exbhP2SWJSbu/7jVe9lhi5yc3bil5g6acVfb97aeipj8L
	9VZiKc5INNRiLipOBAAW3g4mWwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Richard Purdie as backlight subsystem maintainer, since he
is not responding for a few years.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 146ade4..398819c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1645,7 +1645,6 @@ S:	Maintained
 F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
-M:	Richard Purdie <rpurdie@rpsys.net>
 M:	Jingoo Han <jg1.han@samsung.com>
 S:	Maintained
 F:	drivers/video/backlight/
-- 
1.7.10.4


