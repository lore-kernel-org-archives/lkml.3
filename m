Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3EFEYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:24:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFEYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:24:42 -0400
X-AuditID: cbfee690-b7f136d000000fea-1c-51873082e865
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 8/8] twl4030_charger: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:24:33 +0900
Message-id: <003d01ce4a11$9c803370$d5809a50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEYl5+HtnbSyJT5iHQvAFIM6RKQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI90mg/ZAg67ZQhYHt2paTFw5mdni
	8sJLrBaXd81hs5j18QerA6vHhP5PjB6bV2h59G1Zxehx/MZ2Jo/Pm+QCWKO4bFJSczLLUov0
	7RK4MtpaDjIVHOao+NJ1h7GBcQZ7FyMnh4SAicSEw1MYIWwxiQv31rOB2EICyxglpq5Jg6k5
	fOswUJwLKL6IUeLQl1Yo5xejxL+lM8EmsQmoSXz5chjMFhHQkGhbPYUFpIhZYCqjxP/5E5hB
	EsIC/hILZ+8Csjk4WARUJY5sCQIJ8wpYSjy68IQZwhaU+DH5HguIzSygJbF+53EmCFteYvOa
	t8wQFylI7Dj7mhFil55Ey7yZrBA1IhL7XrxjBNkrIbCPXeLdhR1gg1gEBCS+TT7EArJXQkBW
	YtMBqDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn
	525ihMTdhB2M9w5YH2JMBlo/kVlKNDkfGLd5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamA0PLQ/w8f0mOCVJOO8HqfLe1aHL22tr35ywfBDjFxO
	OEuT7kEB9pTck6b3vvs1HP5tpqI6kUEhbkvR/lenHmvXJlppe/5Ze984+8tM+TOr0s0q31TN
	/3tglXX60kf57xbvMfFSlr90fIW8vYuifb3DpkkPF73es9a8SSFiT/FRgVjTp+YqN1YrsRRn
	JBpqMRcVJwIA/I47j9ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd0mg/ZAgwUb+CwObtW0mLhyMrPF
	5YWXWC0u75rDZjHr4w9WB1aPCf2fGD02r9Dy6NuyitHj+I3tTB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWa0tRxkKjjMUfGl6w5jA+MM9i5GTg4JAROJw7cO
	s0HYYhIX7q0Hsrk4hAQWMUoc+tIK5fxilPi3dCZYB5uAmsSXL4fBbBEBDYm21VNYQIqYBaYy
	SvyfP4EZJCEs4C+xcPYuIJuDg0VAVeLIliCQMK+ApcSjC0+YIWxBiR+T77GA2MwCWhLrdx5n
	grDlJTavecsMcZGCxI6zrxkhdulJtMybyQpRIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiy
	ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4rp9J7WBc2WBxiFGAg1GJh7fgSVugEGtiWXFl
	7iFGCQ5mJRFen71AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hppy8knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamA89OOdqEb2vJNyYttU7v+Xq61qERDQ
	D75evZVZNjF/6kXzdcc+XvsZe7d13rQbH/dszI6x5JjAYLS5sa0k7eb6uQcmi8693Vgu9GHv
	b9kr1hfVdwkv9gz7XCB1x+WpYoVd+9a8GU+W50RxdrHnuQlXu4a9L1YPTP6z9PuJaV9dD5Tl
	Z9tHxT1QYinOSDTUYi4qTgQAdsmH2i8DAAA=
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
 drivers/power/twl4030_charger.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index bed4581..be98e70 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -594,7 +594,6 @@ fail_chg_irq:
 fail_register_usb:
 	power_supply_unregister(&bci->ac);
 fail_register_ac:
-	platform_set_drvdata(pdev, NULL);
 	kfree(bci);
 
 	return ret;
@@ -622,7 +621,6 @@ static int __exit twl4030_bci_remove(struct platform_device *pdev)
 	free_irq(bci->irq_chg, bci);
 	power_supply_unregister(&bci->usb);
 	power_supply_unregister(&bci->ac);
-	platform_set_drvdata(pdev, NULL);
 	kfree(bci);
 
 	return 0;
-- 
1.7.2.5


