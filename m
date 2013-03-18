Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3CRJbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:31:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48508 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3CRJa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:30:59 -0400
X-AuditID: cbfee690-b7f656d0000007e3-24-5146ded123ff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 04/10] rtc: rtc-rc5t583: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:30:56 +0900
Message-id: <01ba01ce23bb$4b5a03d0$e20e0b70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAACAcA
Content-language: ko
x-cr-hashedpuzzle: GYb/ KG/Y Lc5G PrJa SDeg U/kO VBb1 ZlYv dYgc g2ZY t7Wz uq4E
 xC09 zQTy 34nO
 4ci3;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{3B7C88C5-14F5-4FC2-ABDF-A4C04078A689};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 18 Mar 2013 09:30:48
 GMT;WwBQAEEAVABDAEgAIAAwADQALwAxADAAXQAgAHIAdABjADoAIAByAHQAYwAtAHIAYwA1AHQANQA4ADMAOgAgAHMAdwBpAHQAYwBoACAAdABvACAAdQBzAGkAbgBnACAAUwBJAE0AUABMAEUAXwBEAEUAVgBfAFAATQBfAE8AUABTAA==
x-cr-puzzleid: {3B7C88C5-14F5-4FC2-ABDF-A4C04078A689}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zA92L99wCDXqXCFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MTxMSCnq4K1qPLGdsYOzi7GLk5JAQMJH4/+wZI4QtJnHh3nq2
	LkYuDiGBZYwSN+dNZYQp2nvgNAtEYhGjxOt7m5kgnNlMEsf7brGCVLEJqEl8+XKYvYuRg0NE
	QF+irUUDpIZZoJdR4kzvbnaQGiEBW4l51xaDTeUUsJPY2j8JrFdYwEtizbKpLCA2i4CqxK4P
	38FsXqD6n93/GCFsQYkfk++BxZkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJ64ua
	oEpEJPa9eMcIco+EwBtWiV09h5kgPjOVOD/zEhNE4hC7RPuUJ1BHCEh8m3yIBWKorMSmA8wQ
	9ZISB1fcYJnAKDULyUmzkJw0C8lJs5DsXsDIsopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMj
	JBYn7GC8d8D6EGMy0PqJzFKiyfnAWM4riTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA+P0ope5m5SfHTng9O1b0Nu3HHdc1xbXbE8741DGLuj5Qv2w
	9Y9Fxu6em7Wyt31VE5jcGDa5301vnSL/v8Np1R5hSz/5H4u3373qtZSShN9dpxLuf4vmJoeb
	V2SZ1F2qOuk478SLw7vMSz6apXzI2+1Yv/dOau2eLbz/JeeJZlwVWKi2ab1+RKUSS3FGoqEW
	c1FxIgAoHKkV2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAd2L99wCDdofcllc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjE8TEgp6uCtajyxnbGDs
	4uxi5OSQEDCR2HvgNAuELSZx4d56ti5GLg4hgUWMEq/vbWaCcGYzSRzvu8UKUsUmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u9lBaoQEbCXmXVvMCGJzCthJbO2fBNYrLOAlsWbZVLBt
	LAKqErs+fAezeYHqf3b/Y4SwBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRF
	BIwkri9qgioRkdj34h0jyD0SAm9YJXb1HGaC+MxU4vzMS0wTGEVmIVkxC8mKWUhWzEIyawEj
	yypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Eh/JrWDcWWDxSFGAQ5GJR7eHevdAoVYE8uK
	K3MPMUpwMCuJ8DreBgrxpiRWVqUW5ccXleakFh9iTAaGwERmKdHkfGASyiuJNzQ2MTOyNDKz
	MDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxpls25nna+mJ3WXwzLIrvPooLNIx
	+8WrsM+dcyetOqVXvcutb93OrQklJfNVH8/Tv77vXv6VhAyZmB2uloenzP2rUmT/6F53wawV
	b1X6OvQrXuu63Hm8+xzrdgOZoDcFkaunsf4ImPmv8G2Ltv3d/EMcKTWBi9Y/OPStxXVV5c0D
	Vlvmn1RSuavEUpyRaKjFXFScCADTThEyOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rc5t583.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-rc5t583.c b/drivers/rtc/rtc-rc5t583.c
index eb3194d..1734e97 100644
--- a/drivers/rtc/rtc-rc5t583.c
+++ b/drivers/rtc/rtc-rc5t583.c
@@ -282,7 +282,6 @@ static int rc5t583_rtc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-
 static int rc5t583_rtc_suspend(struct device *dev)
 {
 	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
@@ -304,24 +303,18 @@ static int rc5t583_rtc_resume(struct device *dev)
 	return regmap_write(rc5t583->regmap, RC5T583_RTC_CTL1,
 		rc5t583_rtc->irqen);
 }
-
-static const struct dev_pm_ops rc5t583_rtc_pm_ops = {
-	.suspend	= rc5t583_rtc_suspend,
-	.resume		= rc5t583_rtc_resume,
-};
-
-#define DEV_PM_OPS     (&rc5t583_rtc_pm_ops)
-#else
-#define DEV_PM_OPS     NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(rc5t583_rtc_pm_ops, rc5t583_rtc_suspend,
+			rc5t583_rtc_resume);
+
 static struct platform_driver rc5t583_rtc_driver = {
 	.probe		= rc5t583_rtc_probe,
 	.remove		= rc5t583_rtc_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "rtc-rc5t583",
-		.pm	= DEV_PM_OPS,
+		.pm	= &rc5t583_rtc_pm_ops,
 	},
 };
 
-- 
1.7.2.5


