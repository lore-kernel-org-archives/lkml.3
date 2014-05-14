Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaENE6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:58:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17065 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaENE6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:58:08 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-4f-5372f7de4497
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tejun Heo'" <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] workqueue: Remove deprecated system_nrt[_freezable]_wq
Date: Wed, 14 May 2014 13:58:06 +0900
Message-id: <002101cf6f31$18262f30$48728d90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9vMRgSVtpd1gV6S/2nhIBeOb2law==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zQ91734uCDb5cN7a4vPASq8XlXXPY
	LH4tP8rowOyxaVUnm0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlbO6cwFRwlatixp+PbA2M
	Uzm7GDk5JARMJE5u+8kGYYtJXLi3Hsjm4hASWMYosW7zbmaYoqf7nzBDJKYzSjy61coE4fxm
	lLi9ezpYFZuAmsSXL4fZQWwRAXmJK0/OAY3i4GAWcJE4Ok0EJCws4C6x8U0XI4jNIqAq0T9h
	CROIzStgK/Hm1wJ2CFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jKDjJQQUJd49FcXYpOexM6X
	F9ggSkQk9r14xwhymoTAKnaJva1nWSB2CUh8m3yIBaJXVmLTAai/JCUOrrjBMoFRbBaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiJqAk7GO8dsD7EmAy0fiKz
	lGhyPjAi80riDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qB0TbkdU2p6XvLH/OubI5n1ll5dnPv59up7vZ/N/1lv66vctl5Fs+h3Q0LV97f8JXx1rly
	UyZP7pxi3p4bnl+vNjBsOv/0yROvfpN72t3/LppMnb0vWGe17cxMXt5uWz/jKpWJNW1/vGcL
	FzuaiV7e8vxNZ8Claf4iG6wmCwixSSlHnmFiurFsoRJLcUaioRZzUXEiAPB30QO+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoO6970XBBu2NBhaXF15itbi8aw6b
	xa/lRxkdmD02repk8+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjM2dE5gKrnJVzPjzka2BcSpnFyMnh4SAicTT/U+YIWwxiQv31rN1MXJxCAlMZ5R4
	dKuVCcL5zShxe/d0sCo2ATWJL18Os4PYIgLyEleenAPq4OBgFnCRODpNBCQsLOAusfFNFyOI
	zSKgKtE/YQkTiM0rYCvx5tcCdghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg4yUEFCXePRX
	F2KTnsTOlxfYIEpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBMfrM6kdjCsbLA4xCnAwKvHw3nAuChZiTSwrrsw9xCjBwawkwlu+BSjEm5JY
	WZValB9fVJqTWnyIMRno0YnMUqLJ+cBUklcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjJskGVaUWE9XKMqUmJyk/TfmmsumKb/yrfqW37vYecvvplnbr6+a
	hjHO/FwXpqgeezbppVXHztn/fXxb+56tLlZl07F153pdVKO5Qkdh9Sa38HtP2GKe550/u41f
	8mPz/Xd7fjxYGKYtcGz2b7tS2Qk7lnyYcWjrJSvu6DO7U0WCZr27q//wv4gSS3FGoqEWc1Fx
	IgCFg9BzGwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system_nrt[_freezable]_wq were deprecated by 3b07e9c ("workqueue:
deprecate system_nrt[_freezable]_wq") and have been deprecated
for a long time. In addition, these are not used anymore. So,
let's remove these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/linux/workqueue.h |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 1b22c42..11dcc89 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -364,20 +364,6 @@ extern struct workqueue_struct *system_freezable_wq;
 extern struct workqueue_struct *system_power_efficient_wq;
 extern struct workqueue_struct *system_freezable_power_efficient_wq;
 
-static inline struct workqueue_struct * __deprecated __system_nrt_wq(void)
-{
-	return system_wq;
-}
-
-static inline struct workqueue_struct * __deprecated __system_nrt_freezable_wq(void)
-{
-	return system_freezable_wq;
-}
-
-/* equivlalent to system_wq and system_freezable_wq, deprecated */
-#define system_nrt_wq			__system_nrt_wq()
-#define system_nrt_freezable_wq		__system_nrt_freezable_wq()
-
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	struct lock_class_key *key, const char *lock_name, ...) __printf(1, 6);
-- 
1.7.10.4


