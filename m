Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790Ab3ECGbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:31:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60844 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762722Ab3ECGbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:31:41 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-c2-518359cc90e7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 21/42] rtc: rtc-ls1x: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:31:39 +0900
Message-id: <002301ce47c7$decf3ab0$9c6db010$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx9uNrntO4hOZRuiJSkGfaSRfCQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA90zkc2BBo+/y1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcXPPObaCt6wVO2ebNjA+Y+li5OSQEDCRuD5pMROELSZx4d56ti5GLg4hgWWMEjfv
	rmKDKbp77TI7RGI6o0T3xWZGCOcXo8TKa7sZQarYBNQkvnw5DFTFwSEioC/R1qIBUsMs0M0o
	8ah5LjNIjbCAv8S2I9/B1rEIqEr03jwP1ssrYCnx4dE3FghbUOLH5HtgNrOAlsT6nceZIGx5
	ic1r3jJDXKQgsePsa7BeEQE9iWktv6BqRCT2vXgHdpyEwCF2ie5pj6CWCUh8m3yIBeQ4CQFZ
	iU0HoOZIShxccYNlAqPYLCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpec
	n7uJERJ7fTsYbx6wPsSYDLR+IrOUaHI+MHbzSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cAofuHUrOU7pPQ2S+3jV514vOGZ8Jt40wpzk2KP+rTE
	nFDt2evrecq43zaqffNxm/ZuYtVe70L2pCU/96pL3j7Ef6rmq/uPt2mtRhtXrTdq7XyXz6jq
	9bVt6u2tHhyH+CO6/wmK3dxtMY0z4GhhC8upJjmJZ7MbDnzu3sx5YLLnOZ2dh5effvNeiaU4
	I9FQi7moOBEATEOU/9MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd0zkc2BBj3dUhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZtzcc46t4C1rxc7Zpg2Mz1i6GDk5JARMJO5e
	u8wOYYtJXLi3nq2LkYtDSGA6o0T3xWZGCOcXo8TKa7sZQarYBNQkvnw5DNTBwSEioC/R1qIB
	UsMs0M0o8ah5LjNIjbCAv8S2I9+ZQGwWAVWJ3pvnwXp5BSwlPjz6xgJhC0r8mHwPzGYW0JJY
	v/M4E4QtL7F5zVtmiIsUJHacfQ3WKyKgJzGt5RdUjYjEvhfvGCcwCsxCMmoWklGzkIyahaRl
	ASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgyH4mvYNxVYPFIUYBDkYlHl6FlqZAIdbE
	suLK3EOMEhzMSiK8bj+AQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTDp5JfGGxiZmRpZG
	ZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDIvlCXe2+GV5fJ+xleKcXOMq1T
	T2dEzlnXNS+trJUndt5+/m7JL19fcjbIme9c9zT+YcL25oCPXKEb3VYfMbp9s/imV2vDy5Dd
	hUetrEwd+6pfxiXkZvorO+17M4lZ41Dr4Rl+lzcJtUgZPelVqIjkd2G5yZhme7TpnWLiWkfv
	uJU/lLMYdyuxFGckGmoxFxUnAgCd0BwHMAMAAA==
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
 drivers/rtc/rtc-ls1x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ls1x.c b/drivers/rtc/rtc-ls1x.c
index db82f91..e913f38 100644
--- a/drivers/rtc/rtc-ls1x.c
+++ b/drivers/rtc/rtc-ls1x.c
@@ -187,8 +187,6 @@ err:
 
 static int ls1x_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


