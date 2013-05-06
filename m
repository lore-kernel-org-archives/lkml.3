Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3EFDaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:30:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24349 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3EFDau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:30:50 -0400
X-AuditID: cbfee691-b7fe56d000004b96-d2-518723e949d4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        "'Gabriel Fernandez'" <gabriel.fernandez@stericsson.com>
Subject: [PATCH 4/7] gpio: stmpe: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:30:49 +0900
Message-id: <001a01ce4a0a$1a72e9b0$4f58bd10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCe3JRaoOGp4LRbSKX3fmAj1NHw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ92Xyu2BBp+u6ljs2O5i8erMRjaL
	ywsvsVpM+bOcyeLyrjlsDqwed67tYfPo27KK0ePnSx2P70vXsHt83iQXwBrFZZOSmpNZllqk
	b5fAlfFu51Tmgo1sFY27trM1MC5h7WLk5JAQMJHYdOg7C4QtJnHh3nq2LkYuDiGBZYwSZ/+f
	hyuacG4yVGIRo8THCYdYIJxfjBL9By+wg1SxCahJfPlyGMwWEdCTuHGhgxGkiFlgFaPE1Y6Z
	jCAJYQFviR9/VoAVsQioSjydspkZxOYVsJTY+2kKI4QtKPFj8j2wm5gFtCTW7zzOBGHLS2xe
	85YZ4iQFiR1nXzPCLHu64DkrRI2IxL4X78AWSwjsY5c4cXEeE8QyAYlvk0HO5gBKyEpsOgA1
	R1Li4IobLBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQ
	2Ju4g/H+AetDjMlA6ycyS4km5wNjN68k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjFKXBQX2r1ba7f78cd2KgmQvQ6UqoUy/D0t+hYTFvf6XKfhB
	8lfGS5v0oo8HZxTqVf824u7a5qXl/4LTjm9tL9+Xqa+6ipiPhiaF5/va2Gx+csG8/gm/aOA0
	x9OXTb+350Vad/p+yrkS/aRmwf8tsSILp/wsnL/8QNop16wf7SembG7eO6X5sRJLcUaioRZz
	UXEiADqN7z/TAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd2Xyu2BBi82aFjs2O5i8erMRjaL
	ywsvsVpM+bOcyeLyrjlsDqwed67tYfPo27KK0ePnSx2P70vXsHt83iQXwBrVwGiTkZqYklqk
	kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RbSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jxbudU5oKNbBWNu7azNTAuYe1i5OSQEDCRmHBu
	MhuELSZx4d56IJuLQ0hgEaPExwmHWCCcX4wS/QcvsINUsQmoSXz5chjMFhHQk7hxoYMRpIhZ
	YBWjxNWOmYwgCWEBb4kff1aAFbEIqEo8nbKZGcTmFbCU2PtpCiOELSjxY/I9FhCbWUBLYv3O
	40wQtrzE5jVvmSFOUpDYcfY1I8yypwues0LUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO7GdSOxhXNlgcYhTgYFTi4S140hYoxJpYVlyZ
	e4hRgoNZSYTXZy9QiDclsbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OBSSevJN7Q2MTMyNLIzMLI
	xNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhneT/49u91xcF795dE5006z7ZX77GG
	SMg5FhW/pJZHdyY/3xv1xGY5y7Yi6wOsZ/WOK9Qcv5m06BrfrK4Kr+aXSganbM1uhG5Ojz9l
	2S4Vbc/4pN55YX0HwybPxVtYLybNPdSx+0fSJuVzHueOL9eQYP/Vy51sxCs2Jf9W6DbTvzOb
	Tn078L5biaU4I9FQi7moOBEA1NVPsjADAAA=
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
 drivers/gpio/gpio-stmpe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 3ce5bc3..671913e 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -431,7 +431,6 @@ static int stmpe_gpio_remove(struct platform_device *pdev)
 	if (irq >= 0)
 		free_irq(irq, stmpe_gpio);
 
-	platform_set_drvdata(pdev, NULL);
 	kfree(stmpe_gpio);
 
 	return 0;
-- 
1.7.2.5


