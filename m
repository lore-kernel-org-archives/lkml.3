Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab3GPLxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:53:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17912 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3GPLxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:53:04 -0400
X-AuditID: cbfee691-b7fef6d000002d62-3a-51e5341e9cde
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, sbkim73@samsung.com,
        sameo@linux.intel.com, mturquette@linaro.org, lee.jones@linaro.org,
        broonie@kernel.org, yadi.brar01@gmail.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 3/3] mfd: s2mps11: Remove clocks from regulators list
Date: Sun, 07 Jul 2013 17:14:22 +0530
Message-id: <1373197462-4033-4-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSpytn8jTQ4PxyXYupD5+wWdz/epTR
	YtPja6wWl3fNYbN4OuEim8XpblaLiyu+MFnM/d3IajFn+jsmB06PnbPusntsWtXJ5nHn2h42
	j3knAz02L6n36NuyitHj8ya5APYoLpuU1JzMstQifbsEroxVP7exFDzjqDh3dzp7A+Nu9i5G
	Tg4JAROJ75/3s0HYYhIX7q0Hsrk4hASWMkocX/4ArujmlC0sEInpjBLdr34zQzhtTBI7ll0D
	auHgYBMwknh1zA6kQURAQWJz7zNWkBpmgQeMEg/fbWYFSQgLuErsmHKZCcRmEVCV2HPnOpjN
	K+Ai0b2plRlim4JE67JDYJs5gepPH1nODjJfCKhm5ikJkJkSAtvYJSbv+w01R0Di2+RDLCA1
	EgKyEpsOQI2RlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECI+H0v2cT
	dzDeP2B9iDEZaNxEZinR5HxgJOWVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgXHm9709f13vdIXKdj3n6WeJvBDGnZ52wrLw25PdT5WTa69VG4dm
	5Epe2BLptnZqZI1BQGKU3pzXqsusHiTlSDguUU113yEoszjxpUy5gf4c7x1/omfe4luxM/b/
	5RkO7t2WP7wXBXlv0V69YvOqSVz6H5jdf8lnRjA98Et7eN1jfc1ujZ7Lj5VYijMSDbWYi4oT
	Ab8nBqaaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQV05k6eBBnPnq1lMffiEzeL+16OM
	FpseX2O1uLxrDpvF0wkX2SxOd7NaXFzxhcli7u9GVos5098xOXB67Jx1l91j06pONo871/aw
	ecw7GeixeUm9R9+WVYwenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGHMWPVzG0vBM46Kc3enszcw7mbvYuTkkBAwkbg5ZQsLhC0mceHeerYuRi4OIYHpjBLdr34z
	QzhtTBI7ll0DynBwsAkYSbw6ZgfSICKgILG59xkrSA2zwANGiYfvNrOCJIQFXCV2TLnMBGKz
	CKhK7LlzHczmFXCR6N7UygyxTUGiddkhsCs4gepPH1nODjJfCKhm5imJCYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEx9kz6R2MqxosDjEKcDAq8fAe5HwSKMSaWFZcmXuIUYKD
	WUmE9xb/00Ah3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgemgLySeENjE3NTY1NLEwsTM0vS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYMz+J/tKJT3sxVGBrBcbGV84x1zonLatUSS+
	RHRP2OVlAXonA7WM74mLVLs8zp+wjPevjvLlvJ6pBdPf2j2q79s2+XtCX693+rlVFivTgFG0
	LjLuRkZk2iQR888b9kY+UtDJyP0sLWVv/vc/H1v4lESO33NuMtatM3E9bvG489mFH5frdUJE
	lViKMxINtZiLihMBEnTHPvcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since these are fixed rate clocks which are registered with common clock
framework so remove these from list of regulators which were unnecessarily
incrementing the count(S2MPS11_REGULATOR_MAX) of regulators.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 include/linux/mfd/samsung/s2mps11.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
index d0d52ea..b3ddf98 100644
--- a/include/linux/mfd/samsung/s2mps11.h
+++ b/include/linux/mfd/samsung/s2mps11.h
@@ -167,11 +167,8 @@ enum s2mps11_regulators {
 	S2MPS11_BUCK8,
 	S2MPS11_BUCK9,
 	S2MPS11_BUCK10,
-	S2MPS11_AP_EN32KHZ,
-	S2MPS11_CP_EN32KHZ,
-	S2MPS11_BT_EN32KHZ,
 
-	S2MPS11_REG_MAX,
+	S2MPS11_REGULATOR_MAX,
 };
 
 #define S2MPS11_BUCK_MIN1	600000
@@ -203,6 +200,5 @@ enum s2mps11_regulators {
 #define S2MPS11_BUCK4_RAMP_EN_SHIFT	1
 #define S2MPS11_BUCK6_RAMP_EN_SHIFT	0
 #define S2MPS11_PMIC_EN_SHIFT	6
-#define S2MPS11_REGULATOR_MAX (S2MPS11_REG_MAX - 3)
 
 #endif /*  __LINUX_MFD_S2MPS11_H */
-- 
1.7.0.4

