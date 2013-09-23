Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3IWJxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:53:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58046 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3IWJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:53:40 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-9d-52400fa2d736
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Raphael Assenat'" <raph@8d.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 15/15] rtc: rtc-v3020: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:53:38 +0900
Message-id: <002b01ceb842$c70a0cc0$551e2640$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAgmdg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ91F/A5BBpe+G1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF0zO3GC32d3YwOrB5/N+8iNFjz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGVMmfmJteAAW8WLXS2sDYybWbsYOTkkBEwkjk+9wwRhi0lcuLee
	rYuRi0NIYBmjxKIpf5lhihrvLWGFSExnlJh/aDNU1S9GifaG5SwgVWwCahJfvhxm72Lk4BAR
	0Jdoa9EAqWEW2MAocXDzFzaQGiEBW4mJ076CreMUsJNY83kZmC0MFP+7+BzYSSwCqhIzfi9i
	BpnDCxS/saMUJMwrICjxY/I9sFXMAloSm7c1sULY8hKb17wFK5cQUJd49FcXJCwiYCQxZcp5
	qBIRiX0v3jGCnCMh8JFdYvWpR+wQqwQkvk0+xALRKyux6QDUv5ISB1fcYJnAKDELyeZZSDbP
	QrJ5FpIVCxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKERO/EHYz3D1gfYkwGWj+RWUo0
	OR8Y/Xkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YAz77Sp09toEvl9vlt/ne7alpInv06WvH/IZv8yZM3NpmDoH2/R36b5CJvNrDvyZxLS+UsTT
	mXuTyLPokoQd634lfmOKfvnW0qX2ybIm403aHreessx967pglktH9dxMR4mO7tR1srvZF/Du
	O1qUOePQk8r/FRzRrfNWJJn9Sr36X3+C1LL3nxcpsRRnJBpqMRcVJwIAa01KD/QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd1F/A5BBocn6VosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF0zO3GC32d3YwOrB5/N+8iNFjz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmDLzE2vBAbaKF7taWBsY
	N7N2MXJySAiYSDTeWwJli0lcuLeerYuRi0NIYDqjxPxDm6GcX4wS7Q3LWUCq2ATUJL58Ocze
	xcjBISKgL9HWogFSwyywgVHi4OYvbCA1QgK2EhOnfWUCsTkF7CTWfF4GZgsDxf8uPge2jUVA
	VWLG70XMIHN4geI3dpSChHkFBCV+TL4HtopZQEti87YmVghbXmLzmrdg5RIC6hKP/uqChEUE
	jCSmTDkPVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjODU8k97BuKrB4hCjAAejEg9vZKJ9kBBrYllxZe4hRgkOZiURXj9WhyAh3pTEyqrU
	ovz4otKc1OJDjMlAf05klhJNzgemrbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRm
	p6YWpBbBbGHi4JRqYFx9sv/Ji7aKgwUXDu+aeLOjY5Fg+R9urvJ7Wps3HAtSOJwkd8TwzceZ
	907uquGdyPQq1yH/7deytWudDzgduMmSV3F0pn/wgufVO08/iPiYxyY5V/i+ZvPlBxKLUpl9
	eDmk398oY41j82JMORrx+U/8G96ndyo7w9Z4Kjz2qG5fujBYvJ2xUEGJpTgj0VCLuag4EQC/
	+2s8UQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-v3020.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index d07d898..25222cd 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -303,7 +303,7 @@ static const struct rtc_class_ops v3020_rtc_ops = {
 
 static int rtc_probe(struct platform_device *pdev)
 {
-	struct v3020_platform_data *pdata = pdev->dev.platform_data;
+	struct v3020_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct v3020 *chip;
 	int retval = -EBUSY;
 	int i;
-- 
1.7.10.4


