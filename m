Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613Ab3BOHpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:45:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43355 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935514Ab3BOHps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:45:48 -0500
X-AuditID: cbfee690-b7f066d00000169f-99-511de7a241a0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: max77686: add missing variable initialization
Date: Fri, 15 Feb 2013 16:45:38 +0900
Message-id: <003601ce0b50$726cb860$57462920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LUHJQndSSbyiORLuYnsuswOzL2w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t8zfd1Fz2UDDX581LO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjyY+YStoYKuYdHgBSwNjA2sXIyeHhICJRMftVywQtpjEhXvr
	2boYuTiEBJYxSlw438MIU3Rh6jYmEFtIYDqjxNL9IRBFs5kkbp68CDaJTUBN4suXw+xdjBwc
	IgL6Em0tGiA1zAK9jBJnenezg9QICzhLfH96hxWkhkVAVaL3TzyIyStgK7H3YSBIBa+AoMSP
	yffA7mEW0JLYvK2JFcKWl9i85i0zSLmEgLrEo7+6IGERAT2J7de3M0OUiEjse/GOEWSrhEA/
	u0Tz12lgW1kEBCS+TT7EAtErK7HpADPEV5ISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGK
	phYkFxQnpReZ6BUn5haX5qXrJefnbmKERMmEHYz3DlgfYkwGWj+RWUo0OR8YZXkl8YbGxiZm
	JqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjOf8qMGYWKr8u+
	RvutbnzUv62FUz/De82JRfd4pofLiM3TzNvX9XDNWl3FawXfs6OfL1y+5Ed9+Npcx6Ptxj+c
	9Hyltz7IahS2CXV+lMqVuFt5ivudwx8v1KyoOrhikm/mmpzPAr2L7pvcWFt+LiLy2+X5Stv2
	HojJsTffG880pdqKM7akT0yJpTgj0VCLuag4EQA0NPHrqAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jQd1Fz2UDDd40a1tc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEcTn7AVNLBVTDq8gKWB
	sYG1i5GTQ0LAROLC1G1MELaYxIV769lAbCGB6YwSS/eHdDFyAdmzmSRunrwI1sAmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u9lBaoQFnCW+P73DClLDIqAq0fsnHsTkFbCV2PswEKSC
	V0BQ4sfkeywgNrOAlsTmbU2sELa8xOY1b5lByiUE1CUe/dUFCYsI6Elsv76dGaJERGLfi3eM
	ExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAMPpPewbiq
	weIQowAHoxIPr4CEbKAQa2JZcWXuIUYJDmYlEV65W0Ah3pTEyqrUovz4otKc1OJDjMlAb05k
	lhJNzgemh7ySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwNgk
	d+RYgoAeU6LZzDc/RThWLmx6xdzld5RFxbBsIZfaMWO9Reo/airrS6ym/pomVP5U0c5xR0hb
	1fYPkffsXy8wt8/iW3rUcpp63cFrC2cL+D9zfSvduzuRW3nNr+/8adMWbj2wNPlV77md59az
	nKzIVXz2SDhVY1qSBu+t6Teu379n1zOVlUOJpTgj0VCLuag4EQCjMv9NBQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed build warning as below:

drivers/rtc/rtc-max77686.c: In function 'max77686_rtc_update':
drivers/rtc/rtc-max77686.c:147:6: warning: 'data' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index abe27c0..2634fed 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -133,7 +133,7 @@ static int max77686_rtc_update(struct max77686_rtc_info *info,
 	enum MAX77686_RTC_OP op)
 {
 	int ret;
-	unsigned int data;
+	unsigned int data = 0;
 
 	switch (op) {
 	case MAX77686_RTC_WRITE:
-- 
1.7.2.5


