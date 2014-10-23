Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaJWEGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:06:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJWEGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:06:19 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-9f-54487eb92125
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
To: akpm@linux-foundation.org, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de,
        liwanp@linux.vnet.ibm.com, qiuxishi@huawei.com,
        linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, vishu13285@gmail.com,
        Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH] lib: show_mem: This patch adds cma reserved infromation
Date: Thu, 23 Oct 2014 09:33:51 +0530
Message-id: <1414037031-20548-1-git-send-email-vishnu.ps@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkTndnnUeIweQZQhZz1q9hs3h5SNOi
	7dg/FovLu+awWWw7vIPJYvK7Z4wWfd8Ps1t8m7ab0aJtyUYmiyl9dxkttqx4yOrA7bFz1l12
	jwWbSj1ajrxl9Tjx5BKbx4kZv1k8HhzazOLRt2UVo8fm09UenzfJBXBGcdmkpOZklqUW6dsl
	cGVMunqEtaCHs+LspGPMDYxn2LsYOTkkBEwkWroWMkPYYhIX7q1n62Lk4hASWMooMXHjRVaY
	oru3DjFBJBYxStw59gTK+cMocePHbyaQKjYBQ4kNs4+wgyREBLYySvQfuc8GkmAWyJP4ePsn
	2A5hAQ+J/UsOgMVZBFQllq+9AbaCV8BVYs+KXqh1ChLLvqxlBhkkIbCLXeL6pBfsEA0CEt8m
	H2LpYuQASshKbDoAdbekxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREY
	Baf/PZuwg/HeAetDjAIcjEo8vBXJHiFCrIllxZW5hxhNgTZMZJYSTc4HxlpeSbyhsZmRhamJ
	qbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYox6mTp5290NNPptV2P/+
	ODaXKY0/m07vPbHlhuP9acEZRftzZmvLLk7WvjzTO/CltYnJUbHZlrY8gjcrws5HrLu72IIx
	wyzuh0BR0f8HV2/J2L43mVk6tzhtyZHyo0++/92t7JmZWf3V2Tb+/zvJlQG5ApvmNIjYC+pY
	lPw58XTtpBlH2RpvK7EUZyQaajEXFScCAMNm4ah9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jAd2ddR4hBtv3c1rMWb+GzeLlIU2L
	tmP/WCwu75rDZrHt8A4mi8nvnjFa9H0/zG7xbdpuRou2JRuZLKb03WW02LLiIasDt8fOWXfZ
	PRZsKvVoOfKW1ePEk0tsHidm/GbxeHBoM4tH35ZVjB6bT1d7fN4kF8AZ1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYxY9LVI6wFPZwVZycdY25gPMPexcjJISFgInH31iEm
	CFtM4sK99WxdjFwcQgKLGCXuHHvCBOH8YZS48eM3WBWbgKHEhtlH2EESIgJbGSX6j9xnA0kw
	C+RJfLz9kxnEFhbwkNi/5ABYnEVAVWL52husIDavgKvEnhW9rBDrFCSWfVnLPIGRewEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Bh7JrWDcWWDxSFGAQ5GJR7eimSPECHWxLLiytxD
	jBIczEoivLXWQCHelMTKqtSi/Pii0pzU4kOMpkDbJzJLiSbnA+M/ryTe0NjE3NTY1NLEwsTM
	Ukmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDo8DJ0k+RC6+wbNht+1SuS5bh4JQvApa3wvTt
	1xWv3jtzcu38SYsUYtS3fl+kuavf9/jHNwUfsnN5jWoP7NL1dvTwznoodfESV6an/+yQL5O+
	C1vNjgkKSd7YtO5AxNIlsisW7NpyPP+vkuTqxwsMunfcl/dQ1e+Kv20b9/Lbm1PVN0Us/aza
	3iqxFGckGmoxFxUnAgD5RhhqxwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds cma reserved information which is currently
shown as a part of total reserved only. This patch is
continuation of our previos cma patches related to this.
https://lkml.org/lkml/2014/10/20/64
https://lkml.org/lkml/2014/10/22/383

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 lib/show_mem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/show_mem.c b/lib/show_mem.c
index 0922579..a0e50d7 100644
--- a/lib/show_mem.c
+++ b/lib/show_mem.c
@@ -8,6 +8,9 @@
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
+#ifdef CONFIG_CMA
+#include <linux/cma.h>
+#endif
 
 void show_mem(unsigned int filter)
 {
@@ -38,7 +41,12 @@ void show_mem(unsigned int filter)
 
 	printk("%lu pages RAM\n", total);
 	printk("%lu pages HighMem/MovableOnly\n", highmem);
+#ifdef CONFIG_CMA
+	printk("%lu pages reserved\n", (reserved - totalcma_pages));
+	printk("%lu pages cma reserved\n", totalcma_pages);
+#else
 	printk("%lu pages reserved\n", reserved);
+#endif
 #ifdef CONFIG_QUICKLIST
 	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
-- 
1.8.3.2

