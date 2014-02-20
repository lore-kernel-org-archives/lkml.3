Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaBTQYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:24:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34679 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbaBTQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:47 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-8a-53062c4c884f
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v4 6/6] tracing/trivial: Add CLOCK_*_DEFERRABLE for tracing
 clockids
Date: Thu, 20 Feb 2014 20:23:45 +0400
Message-id: <1392913425-29369-7-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xa7o+OmzBBm8WmlvMvXuexWLO+jVs
	Fge3alpc//Kc1eLMb12Ls01v2C0u75rDZrF501RmBw6PCf2fGD3uXNvD5vHu3Dl2jxMzfrN4
	9G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aZTd1sBT/ZKnZ//cDawLiVtYuRk0NCwETiT9c2
	JghbTOLCvfVsXYxcHEICSxklnvz9zgzh9DBJrD3fCFTFwcEmYCCx754tSIOIgI/ErokfmUBq
	mAX6GSXOvFnACFIjLBAmcXJWBkgNi4CqxM/GT2ALeAXcJXp2L2cFKZEQUJCYM8kGxOQU8JDo
	WicDUiEEVHFk4Tm2CYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNjXHYxLj1kd
	YhTgYFTi4T0pxRYsxJpYVlyZe4hRgoNZSYTXXQUoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVGg
	VPSn1Y+cg+r3mFNnrBAyPzdp+fQZz8wEa1otFCuS19QYnMs1P3eu6+nN+Z8OiDOqMc16d1bp
	a3z7VZ/D/C983/G9kKnwf77IkeP7LiGR6U6K/y7ve32giMfrQ82T+5vOxvcuKZL6f3r/pLN1
	OZGfy+/sWpOyrnWWxpuWF9mLHOPUA5gFfq5UYinOSDTUYi4qTgQA/Ero1g4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/trace/events/timer.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 547b79f..ea3119a 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -13,7 +13,13 @@
 			 { CLOCK_MONOTONIC,		"CLOCK_MONOTONIC" },	\
 			 { CLOCK_REALTIME,		"CLOCK_REALTIME" },	\
 			 { CLOCK_BOOTTIME,		"CLOCK_BOOTTIME" },	\
-			 { CLOCK_TAI,			"CLOCK_TAI" }		\
+			 { CLOCK_TAI,			"CLOCK_TAI" },		\
+			 { CLOCK_MONOTONIC_DEFERRABLE,				\
+				"CLOCK_MONOTONIC_DEFERRABLE" },			\
+			 { CLOCK_REALTIME_DEFERRABLE,				\
+				"CLOCK_REALTIME_DEFERRABLE" },			\
+			 { CLOCK_BOOTTIME_DEFERRABLE,				\
+				"CLOCK_BOOTTIME_DEFERRABLE" }			\
 	)
 
 #define hrmode_to_string(hrmode)						\
-- 
1.7.9.5

