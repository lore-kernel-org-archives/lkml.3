Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669Ab3ECG2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:28:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60011 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762628Ab3ECG2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:28:00 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-eb-518358eec35f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 10/42] rtc: rtc-bq4802: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:27:58 +0900
Message-id: <001801ce47c7$5aac7a40$10056ec0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx1fJ5LDAxcy4TVuOGmsopM1NXw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ913Ec2BBmvWq1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8XqGUsFX1ortb48zNTC+Y+li5OSQEDCReHj7BDuELSZx4d56ti5GLg4hgWWMEiuW
	z2WCKzo+jxkisYhRYvrhm6wQzi9GibMbPjCCVLEJqEl8+XIYaBQHh4iAvkRbiwZIDbNAN6PE
	o+a5zCA1wgLBEqu27gWzWQRUJW7cOgF2Bq+ApcT0+9fZIGxBiR+T74HFmQW0JNbvPM4EYctL
	bF7zlhniIgWJHWdfg+0VEdCT6PvczQpRIyKx78U7RpDFEgKH2CWuTVzFDrFMQOLb5EMsIMdJ
	CMhKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0
	veT83E2MkNjr28F484D1IcZkoPUTmaVEk/OBsZtXEm9obGZkYWpiamxkbmlGmrCSOK9ai3Wg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa2/a2slxpfv7kdGdeZJj6J+VjsT5ulQnzn38/W
	t2INn9PvG9SUeZT9+HL1RMkHhTsF/3nd2up8MmK3Lkusw4v5AtGa1yIfOM6ZUF7KvmbytLa7
	vtc23Zm6d/nrHTWmy1yLHwbcsfYR2Nd/fP0UN7uJ8dwr5W3qI6LLC261VvTWz/M+G6a3w0SJ
	pTgj0VCLuag4EQBFAjFL0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd13Ec2BBss+KFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPF6hlLBV9aK7W+PMzUwvmPpYuTkkBAwkXh4
	fB4zhC0mceHeerYuRi4OIYFFjBLTD99khXB+MUqc3fCBEaSKTUBN4suXw+xdjBwcIgL6Em0t
	GiA1zALdjBKPmueCTRIWCJZYtXUvmM0ioCpx49YJsG28ApYS0+9fZ4OwBSV+TL4HFmcW0JJY
	v/M4E4QtL7F5zVuoixQkdpx9DbZXREBPou9zNytEjYjEvhfvGCcwCsxCMmoWklGzkIyahaRl
	ASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgyH4mtYNxZYPFIUYBDkYlHl6FlqZAIdbE
	suLK3EOMEhzMSiK8bj+AQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTDp5JfGGxiZmRpZG
	ZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDoztFiEfOnqp711ywuo4Bloatv
	mecKBi6xdjX/bv58p0bl9g8PMwMCWGpWJXCYX/uyzdhf6szt93ICP1wmSIUUfT+1oYevqC66
	PqvYbpGcYP0JnfIpUT639fr03aX3fLur77rQnNO7aQHTjE9ac9fvWWH8mnMB/x2Dc3fSbs6w
	lBVKsjny20aJpTgj0VCLuag4EQBbiqIxMAMAAA==
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
 drivers/rtc/rtc-bq4802.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-bq4802.c b/drivers/rtc/rtc-bq4802.c
index af28867..b919168 100644
--- a/drivers/rtc/rtc-bq4802.c
+++ b/drivers/rtc/rtc-bq4802.c
@@ -188,8 +188,6 @@ out:
 
 static int bq4802_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


