Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3EFD2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:28:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24371 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3EFD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:28:39 -0400
X-AuditID: cbfee68d-b7f016d000007930-ca-518723653b5c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        "'Mathias Nyman'" <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/7] gpio: lynxpoint: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:28:37 +0900
Message-id: <001801ce4a09$cbf95800$63ec0800$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCa4zYzX7FlaBQSKxYIN1Fu7xrA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd005fZAgwdsFq/ObGSzuLzwEqvF
	lD/LmSwu75rDZvH6QxOLA6vHnWt72DzmnQz06NuyitHj50sdj8+b5AJYo7hsUlJzMstSi/Tt
	ErgyLjesZS54yVax7c0/9gbGm6xdjBwcEgImEr+brbsYOYFMMYkL99azdTFycQgJLGOU+H5q
	JztEwkTi0bQ7TBCJ6YwSr1qPskM4vxgl5uxuZgSpYhNQk/jy5TBYh4iAnsSNCx2MIEXMAosZ
	Je4e3cwGkhAW8Jfo3bcdrIFFQFXixqVXYDavgKXE/72fmCFsQYkfk++xgNjMAloS63ceZ4Kw
	5SU2r3nLDHGSgsSOs68ZYZZda1zMBlEjIrHvxTuwxRIC+9glmp7tgFomIPFt8iEWiJ9lJTYd
	gJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4m
	Rkjc9e5gvH3A+hBjMtD6icxSosn5wLjNK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAOjWpHQr6dvhEImXuP9dTJUUTTnbhfTNh4xwYA327ivGv5Y
	vs7BXHndZJ1/HMs2955ytvv5fMaHewneEzL2vrbtXT713zILk5pFMwqlMpcu3F+q/EfY1MPi
	QdtCrxrWHF0N3ruXlly59uz2frb6x5zz44QXSxYlNypOmG3Ef0NPoKBwSun9RXt/KbEUZyQa
	ajEXFScCAHzCF23RAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd1U5fZAg/2LLS1endnIZnF54SVW
	iyl/ljNZXN41h83i9YcmFgdWjzvX9rB5zDsZ6NG3ZRWjx8+XOh6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZcbljLXPCSrWLbm3/sDYw3WbsYOTkkBEwkHk27
	wwRhi0lcuLeerYuRi0NIYDqjxKvWo+wQzi9GiTm7mxlBqtgE1CS+fDnMDmKLCOhJ3LjQwQhS
	xCywmFHi7tHNbCAJYQF/id5928EaWARUJW5cegVm8wpYSvzf+4kZwhaU+DH5HguIzSygJbF+
	53EmCFteYvOat8wQJylI7Dj7mhFm2bXGxWwQNSIS+168Y5zAKDALyahZSEbNQjJqFpKWBYws
	qxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/uZ9A7GVQ0WhxgFOBiVeHgLnrQFCrEmlhVX
	5h5ilOBgVhLh9dkLFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YNLJK4k3NDYxM7I0MrMw
	MjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG6PN3rinuMluzWbuC9/6u+/mrQ9PV
	2Bi901ZtuPrKz8ns0Z0Hjp78Ce+3lv3p7v0t7fDu0P+df57Jnoy5toCHO3HFxvdCDA42ohdm
	/2Z7mHnmvtAso/Vsz5/u+Hp4Qe3mjCnewn7hj665B8Yfkl/2uV72zHRl9q+ZOw623NwtfTrQ
	6oTI8X1rvJRYijMSDbWYi4oTAdlFteAwAwAA
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
 drivers/gpio/gpio-lynxpoint.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 86c17de..761c470 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -447,7 +447,6 @@ static int lp_gpio_remove(struct platform_device *pdev)
 	err = gpiochip_remove(&lg->chip);
 	if (err)
 		dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


