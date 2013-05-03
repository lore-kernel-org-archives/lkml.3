Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3ECGWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:22:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58498 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203Ab3ECGWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:22:40 -0400
X-AuditID: cbfee691-b7fe56d000004b96-70-518357afdac5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 03/42] rtc: rtc-ab3100: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:22:39 +0900
Message-id: <001101ce47c6$9ca9e640$d5fdb2c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxpdYnFSR5xePTfGLKrjlNWHRzQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zY9314c2BBh9WmlosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsWPBZ5aCHWwV7198Z21gXMvaxcjJISFgIrHv4XkoW0ziwr31bF2MXBxCAssYJY5d
	/sgOU9S/4g4ziC0kMJ1R4uArSYiiX4wS1xq3gnWzCahJfPlyGKiBg0NEQF+irUUDpIZZoJtR
	4lHzXLBmYYFgidcL9rCA2CwCqhL/Gn8xgti8ApYSuw53sUPYghI/Jt8Dq2EW0JJYv/M4E4Qt
	L7F5zVtmiIMUJHacfQ3WKyKgJ/F2/12oGhGJfS/eMULUHGKXeHtPE2KXgMS3yYdYQG6TEJCV
	2HQAaoykxMEVN1gmMIrNQrJ5FpLNs5BsnoVkwwJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5
	uZsYIZE3cQfj/QPWhxiTgdZPZJYSTc4HRm5eSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLp
	iSWp2ampBalF8UWlOanFhxiZODilGhgT5DdKdPafNrrFu2/XWtml3zQ5ky7IpzhYa7x6xSvz
	4ETZ5RROR4to0bysj5J7P+2SdI5b+63Aeum7B3ldpemSAcd2W16d/qbzYUA9w2y209Pmr72k
	wiTHnX9qVqCJ22zl5Qd15WLWn/D5+2LnZeai2AkBPx4YHw8SjFGuUy7+oJx3YdZJywNKLMUZ
	iYZazEXFiQC+uY9I0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd314c2BBhMfGVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFjwWeWgh1sFe9ffGdtYFzL2sXIySEhYCLR
	v+IOM4QtJnHh3no2EFtIYDqjxMFXkl2MXED2L0aJa41bwRrYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDNKPGoeS7YIGGBYInXC/awgNgsAqoS/xp/MYLYvAKWErsOd7FD2IISPybfA6thFtCS
	WL/zOBOELS+xec1bqIMUJHacfQ3WKyKgJ/F2/12oGhGJfS/eMU5gFJiFZNQsJKNmIRk1C0nL
	AkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBkf1MagfjygaLQ4wCHIxKPLwKLU2BQqyJ
	ZcWVuYcYJTiYlUR43X4AhXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmHTySuINjU3MjCyN
	zCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHxknnkV+/bf79/dz5QWJqu7v/r
	ne3xi04RXm+UNpjwid3UrPtTvFMwXsO7+t2caXYHFj3YkC+mpHloUYNTwyEuxVXKv1X/TtJf
	zDx555wFV17c+Wj3OZ67V8puikrgAZPPqfriyksNhQX273i39NLs35WT75Zo7zlteE/ylWaV
	ynZrg08nrpZMU2Ipzkg01GIuKk4EAAMRWyIwAwAA
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
 drivers/rtc/rtc-ab3100.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index 47a4f2c..572208d 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -242,7 +242,6 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 
 static int __exit ab3100_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


