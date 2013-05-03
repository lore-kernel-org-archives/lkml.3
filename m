Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3ECG0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:26:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62644 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3ECG0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:26:43 -0400
X-AuditID: cbfee691-b7fe56d000004b96-ba-518358a265da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 08/42] rtc: rtc-au1xxx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:26:42 +0900
Message-id: <001601ce47c7$2d6ff8e0$884feaa0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxyyUO5jles+YStmTCb/1alIVjg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY91FEc2BBo//6FosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcXNRD1vBP9aK9adXMTYwfmfpYuTkkBAwkXi4ZysbhC0mceHeeiCbi0NIYBmjxIq2
	72wwRVs272GGSExnlFh8ZTE7hPOLUWLlw06wUWwCahJfvhwGSnBwiAjoS7S1aIDUMAt0M0o8
	ap7LDFIjLBAsMbtlHzuIzSKgKvGt/y0jiM0rYClxr/05lC0o8WPyPbCZzAJaEut3HmeCsOUl
	Nq95ywxxkYLEjrOvwepFBPQkdi65BFUjIrHvxTtGkMUSAvvYJc50/WSEWCYg8W3yIRaQ4yQE
	ZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpe
	cn7uJkZI9E3cwXj/gPUhxmSg9ROZpUST84HRm1cSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxmIttyW3cgS8piW2umy4vOFDz/WSR2luPw2at54z
	1pnc0JRvoDzlccNXjuu/p+es9lks+enM5OaY6W+Lv28J5wrap3azh2PiYqtL8lcjD5/i3V/5
	m1lSlGOr3jWXysC1Qm27P/NsEupaq9A+ZcaBpus71/1zXhcb/1XFpHn64tKTui15cpOXz1Vi
	Kc5INNRiLipOBAAGhP7N1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd1FEc2BBrP2a1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHFzUQ9bwT/WivWnVzE2MH5n6WLk5JAQMJHY
	snkPM4QtJnHh3nq2LkYuDiGB6YwSi68sZodwfjFKrHzYCdbBJqAm8eXLYaAEB4eIgL5EW4sG
	SA2zQDejxKPmuWCThAWCJWa37GMHsVkEVCW+9b9lBLF5BSwl7rU/h7IFJX5Mvgc2k1lAS2L9
	zuNMELa8xOY1b6EuUpDYcfY1WL2IgJ7EziWXoGpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsY
	WVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf2M+kdjKsaLA4xCnAwKvHwKrQ0BQqxJpYV
	V+YeYpTgYFYS4XX7ARTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGDaySuJNzQ2MTOyNDKz
	MDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRnVB7y9vj2+5VOXt0H2sY9ee3da5
	j5+mVVc+WXSxJKVSVv90UPsvLsawIo0pK1K27K+VP2Nvb/yldsfDtcoqvCVXez4sUvTl/re6
	MCbib0bnJ8YzBxseOhp8vGbRkqlxMnm3uuzpYw/bz8ceW8YRyNiuvfTyJoZ9pbL//QKevV5z
	yFQkfX77GyWW4oxEQy3mouJEACOLAUUxAwAA
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
 drivers/rtc/rtc-au1xxx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index 7995abc..7c6e7bb 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -118,8 +118,6 @@ out_err:
 
 static int au1xtoy_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


