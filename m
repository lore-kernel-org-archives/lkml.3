Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaBTIml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:42:41 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58402 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaBTImj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:42:39 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-8a-5305bffe8f82
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v3 6/6] tracing/trivial: Add CLOCK_*_DEFERRABLE for tracing
 clockids
Date: Thu, 20 Feb 2014 12:40:33 +0400
Message-id: <1392885633-7787-7-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xa7r/9rMGGyxrYbOYe/c8i8Wc9WvY
	LPp/dbJaXP/ynNXizG9di7NNb9gtLu+aw2axedNUZgcOjzvX9rB5vDt3jt3jxIzfLB5f9uxl
	9ujbsorR4/MmuQC2KC6blNSczLLUIn27BK6MM5u62Qp+slXs/vqBtYFxK2sXIyeHhICJxMGP
	J1ggbDGJC/fWs3UxcnEICSxllDh+djEzhNPDJLH3wjkgh4ODTcBAYt89W5AGEQEfiV0TPzKB
	1DAL9DFK9LW/YgZJCAuESUx+/ZQJxGYRUJXY828r2AZeATeJHXsWMILMkRBQkJgzyQbE5BRw
	l2h4YgNSIQRU8WDLH5YJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE2dcdjEuP
	WR1iFOBgVOLhjbjOEizEmlhWXJl7iFGCg1lJhJcnkzVYiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A2PLSvdj9dyaAi0zsgS4v8xte2K+KPW7H9frZ9W2LVPamTdekdm+8qKLcs+sRw/s0t+kNk6L
	i10stHRn4I25P08yHUnmM1x+p9gqNjdjpd6WVRycN/PfqyyN0OH9YK8f6dF77k2LluFRqcON
	Bx0mF6jvy+39+tUuqumN5cLnl5+27nn6/MOz3p1KLMUZiYZazEXFiQC4Tdu+EAIAAA==
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

