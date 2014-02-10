Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaBJBQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:16:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10676 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaBJBQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:16:20 -0500
X-AuditID: cbfee68f-b7f156d00000276c-f8-52f828636c79
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 6/7] Input: pwm-beepe: remove HAVE_PWM dependencies
Date: Mon, 10 Feb 2014 10:16:19 +0900
Message-id: <003f01cf25fd$b3e274b0$1ba75e10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAASf4w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zQ91kjR9BBhd7JC0OL3rBaHF54SVW
	iyWT57Na3Pz0jdXi8q45bA6sHjtn3WX3WPLmEKtH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZfzYeIqlYBdbxaQ5xg2M81m7GDk5JARMJO42LWaHsMUkLtxbz9bFyMUhJLCMUeLXwsNwRZ+2
	3mWFSExnlNi27ytYQkjgF6PE7bU1IDabgJrEly+HgSZxcIgIGErMWFMFUs8s0M0o8fhSOztE
	va3E3Ib9YDangJ3EvKXfwOYICzhLnGrsA7NZBFQlpi7dyAhi8wLV33u5mxnCFpT4MfkeC4jN
	LKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSWw6s5gVokREYt+Ld4wg90gIXGOX2Hft
	KRPELgGJb5MPsUD0ykpsOsAM8a+kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXF
	SelFxnrFibnFpXnpesn5uZsYIdHZv4Px7gHrQ4zJQOsnMkuJJucDozuvJN7Q2MzIwtTE1NjI
	3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBuPrE4Uj3Whuv04bR9v3R7
	fJz4T6yLmd8wqeumYpsgs/25BRXBchPr2Q9Ilr9KdjW7n/dg7dbHvy3tRV87SSa+/6N9XftG
	aKLyDC79sttnS79lP92bfUkv58KTCg3v2+z7YsUktyh//TtHTVlBv0dY0nft7MguLoVZtVat
	a5a5r0m8ZXQlY5YSS3FGoqEWc1FxIgADykSN5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd1kjR9BBs/niFocXvSC0eLywkus
	Fksmz2e1uPnpG6vF5V1z2BxYPXbOusvuseTNIVaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsY8z4sfEUS8EutopJc4wbGOezdjFyckgImEh82noXyhaT
	uHBvPVsXIxeHkMB0Rolt+76CJYQEfjFK3F5bA2KzCahJfPlymL2LkYNDRMBQYsaaKpB6ZoFu
	RonHl9rZIeptJeY27AezOQXsJOYt/QY2R1jAWeJUYx+YzSKgKjF16UZGEJsXqP7ey93MELag
	xI/J91hAbGYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEhi05nFrBAlIhL7XrxjnMAo
	NAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj/5n0DsZVDRaH
	GAU4GJV4eHf8+R4kxJpYVlyZe4hRgoNZSYT35V2gEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucD01JeSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBaaCb8
	2vmh5FG5+7oC2WW34jY9mrtwgsrz35e3vyl1vcK1eVPtgUSTItGdxZl5O//NkTV/KPHGy/vj
	nF3Hn7ZJJ70uUXB6sLppK+sUVYfpDx6u6Fi5+lq4wuX0zY1LGbhPlOas3c3Be+O466/rzvwa
	f1tNtn2K2J6yyNsqaO8fwxgR/Sutq5n5lViKMxINtZiLihMBUDaEAkEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. However, legacy
PWM drivers were already moved to the generic PWM framework.
Thus, HAVE_PWM should be removed, because HAVE_PWM is not
required anymore.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/input/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index ae74df7..762e6d2 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -470,7 +470,7 @@ config INPUT_PCF8574
 
 config INPUT_PWM_BEEPER
 	tristate "PWM beeper support"
-	depends on PWM && HAVE_PWM
+	depends on PWM
 	help
 	  Say Y here to get support for PWM based beeper devices.
 
-- 
1.7.10.4


