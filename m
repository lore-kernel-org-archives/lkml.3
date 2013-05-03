Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486Ab3ECGWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:22:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20059 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762117Ab3ECGWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:22:15 -0400
X-AuditID: cbfee690-b7f136d000000fea-ff-51835796759c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 02/42] rtc: rtc-88pm860x: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:22:13 +0900
Message-id: <001001ce47c6$8d65aa70$a830ff50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxouWoPwdQDi6RA+e4ruIDwCxPQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA91p4c2BBv+nC1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8XDxVqaCy2wV+zbtYG1gPM7axcjBISFgItG8IKmLkRPIFJO4cG89WxcjF4eQwDJG
	iS2XlrBCJEwkLqzsh0pMZ5R48Xs6M4Tzi1Hi9co1YFVsAmoSX74cZgeZKiKgL9HWogFSwyzQ
	zSjxqHkuM0iNsECoxNd/11lAbBYBVYmdyy6BxXkFLCXWLVjHCGELSvyYfA+shllAS2L9zuNM
	ELa8xOY1b5khLlKQ2HH2NVi9iICeROe596wQNSIS+168YwRZLCFwjF1i6e7njBDLBCS+TT7E
	AvGyrMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLRK07MLS7N
	S9dLzs/dxAiJvQk7GO8dsD7EmAy0fiKzlGhyPjB280riDY3NjCxMTUyNjcwtzUgTVhLnVW+x
	DhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmFnGY/btwr2vfRH14kuO1M16wjCZ28nUznrv
	602GAS6+ecd3lCdKv8+JnK6ydb+1iNgWGYW8l3Pmz75h7OJ3QWf1TLnfMvfS8r3diwRq7n7Z
	Pul9u9Js3/ehi2rkcxZHB1+Raz523We7Xvk8jdJ5169oibYvFq5nyHnYk5M+wWnbW/X1119L
	K7EUZyQaajEXFScCAMMI2UfTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd1p4c2BBt+O8VgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFw8VamgstsFfs27WBtYDzO2sXIySEhYCJx
	YWU/G4QtJnHh3nogm4tDSGA6o8SL39OZIZxfjBKvV64B62ATUJP48uUwexcjB4eIgL5EW4sG
	SA2zQDejxKPmucwgNcICoRJf/11nAbFZBFQldi67BBbnFbCUWLdgHSOELSjxY/I9sBpmAS2J
	9TuPM0HY8hKb17xlhrhIQWLH2ddg9SICehKd596zQtSISOx78Y5xAqPALCSjZiEZNQvJqFlI
	WhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7tZ9I7GFc1WBxiFOBgVOLhVWhpChRi
	TSwrrsw9xCjBwawkwuv2AyjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cC0k1cSb2hsYmZk
	aWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjI2p20tDJ98/+Ovu7S5Xy+zS
	rU1r/Ptib0xqStMOXH9xaph3EN/RmUqPVCdJi7e/fcz470/IwVr/94sLb90N7Np07sSz1l+M
	6ybtm9l3PnnlCpujUyuS+//f9FX5pHYrbPkHkwcRaXlJdv8kfaQuXmRJY/66J+dVm/uKu+7/
	ubnr9CQLp988Eq3EUpyRaKjFXFScCACuxOB2MQMAAA==
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
 drivers/rtc/rtc-88pm860x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 0f2b91b..4e30c85 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -418,7 +418,6 @@ static int pm860x_rtc_remove(struct platform_device *pdev)
 	pm860x_set_bits(info->i2c, PM8607_MEAS_EN2, MEAS2_VRTC, 0);
 #endif	/* VRTC_CALIBRATION */
 
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


