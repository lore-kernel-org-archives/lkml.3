Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaENEnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:43:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26891 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaENEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:43:39 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-90-5372f4791aa2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tejun Heo'" <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] workqueue: Remove deprecated flush[_delayed]_work_sync()
Date: Wed, 14 May 2014 13:43:37 +0900
Message-id: <002001cf6f2f$12170bc0$36452340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9vLxH2xTEQfZHTR3qoKjM/zrNDEQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zQ93KL0XBBnc/aVhcXniJ1eLyrjls
	Fr+WH2V0YPbYtKqTzaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgypmzdw1rQwFmx/+8upgbG
	4+xdjJwcEgImEo/a3zFB2GISF+6tZ+ti5OIQEljGKHH+73QghwOs6PJNHYj4IkaJa9+7mSGc
	34wSx9b1soJ0swmoSXz5chhsqoiAvMSVJ+fAmpkFXCSOThMBCQsLeErMfPoIrIRFQFWi+d9i
	ZhCbV8BW4uScjSwQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlhrhHXeLRX12ITXoS154dYIUo
	EZHY9+IdI8hpEgLL2CVmbLnODLFLQOLb5EMsEL2yEpsOMEP8KylxcMUNlgmMYrOQbJ6FZPMs
	JJtnIVmxgJFlFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZIPPXtYLx5wPoQYzLQ+onMUqLJ
	+cB4zCuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jMtdjArsiji+TTU8+Vzx6rKsT+o8K1/fNoq2nvfT9uGDG2/dGkrabBi+Pdkpuro1rV//ImPg
	SqmQ1nj28mn8a9+L9dSvDPsulRKqeOTS7x2NaRtTPIxLEia8W8f9SqLudVjnzvx52edP9L9Y
	1rfwdILn+tQIw3hxz9ObJv5+yD73pI/v52tm/5RYijMSDbWYi4oTAYFAOWy9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgG7ll6Jgg6b1qhaXF15itbi8aw6b
	xa/lRxkdmD02repk8+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjClb97AWNHBW7P+7i6mB8Th7FyMHh4SAicTlmzpdjJxAppjEhXvr2boYuTiEBBYx
	Slz73s0M4fxmlDi2rpcVpIpNQE3iy5fD7CC2iIC8xJUn59hABjELuEgcnSYCEhYW8JSY+fQR
	WAmLgKpE87/FzCA2r4CtxMk5G1kgbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nLDHGbusSjv7oQ
	m/Qkrj07wApRIiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4Wp9J72Bc1WBxiFGAg1GJh/eGc1GwEGtiWXFl7iFGCQ5mJRHe8i1AId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpK8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5ak
	ZqemFqQWwWxh4uCUamCsVWnlSWwpeM/+6sWZAs4v/LttzNmUXdYePxxWvtnu+rwdKpW/d/gX
	xgR9LZuTeKhr1dnYfVMtbh1YxLnA7NO7LLZ1DXUTDX/LrlszdZJ0SnjKerM3E2aET3Aon37y
	YMDphfmBVwS7fut9T28L6xTjiHlS9tnvbTHHKtn5twpFbR63fp2bUv9ciaU4I9FQi7moOBEA
	eKln9BoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush[_delayed]_work_sync() were deprecated by 4382973 ("workqueue:
deprecate flush[_delayed]_work_sync()") and have been deprecated
for a long time. In addition, these are not used anymore. So,
let's remove these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/linux/workqueue.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 1b22c42..aa92d02 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -587,18 +587,6 @@ static inline bool keventd_up(void)
 	return system_wq != NULL;
 }
 
-/* used to be different but now identical to flush_work(), deprecated */
-static inline bool __deprecated flush_work_sync(struct work_struct *work)
-{
-	return flush_work(work);
-}
-
-/* used to be different but now identical to flush_delayed_work(), deprecated */
-static inline bool __deprecated flush_delayed_work_sync(struct delayed_work *dwork)
-{
-	return flush_delayed_work(dwork);
-}
-
 #ifndef CONFIG_SMP
 static inline long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
-- 
1.7.10.4


