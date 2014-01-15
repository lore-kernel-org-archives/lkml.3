Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaAOFKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:10:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19234 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOFK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:10:29 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-4b-52d61842b19e
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] Documentation / CPU hotplug: Fix the typo in example code
Date: Wed, 15 Jan 2014 14:10:26 +0900
Message-id: <1389762626-28982-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkUNdJ4lqQweGv8hZz1q9hs1jb0MNi
	sbBtCYvF5V1z2Cz6F/YyWax7OZ3FYsGeEgd2j52z7rJ7vFo9k9XjxIzfLB59W1Yxejxa3MLo
	8XmTXABbFJdNSmpOZllqkb5dAlfGm12P2AqOs1VcXPaUvYFxJ2sXIyeHhICJxNG1nUwQtpjE
	hXvr2boYuTiEBJYySnzv6ocrOjL1DyNEYhGjxJ55HcwQThuTxMmpP8Cq2AR0JZ4cuAyWEBFo
	Z5T4vHQrM0iCWcBP4vadmYwgtrCAl8THDTfA4iwCqhK9EzaA2bwCHhI/Xu4D2s0BtE5BYs4k
	G4jN7ewSq5qTIMoFJL5NPsQCUSIrsekAM0SJpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqFec
	mFtcmpeul5yfu4kRGL6n/z3r3cF4+4D1IcZkoHETmaVEk/OB4Z9XEm9obGZkYWpiamxkbmlG
	mrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw3lzvvWylVnfj9jGeAvLYKi9+X
	M+LsnSuNvf7ceKx6dTJPKF9vcgeD9b01s98f7Jll8kXePV5g7+GL0iJMK28rHcx6W/VTm/tc
	/dd32rOYJdcYnDp137rq0MwnPfKMMW63TltbBDKc8JzialQw/Y06X4nAT6ZN1ftuaLA3Ni9+
	tPir7IN7768qsRRnJBpqMRcVJwIAxICNYnUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t9jAV0niWtBBh8mSFrMWb+GzWJtQw+L
	xcK2JSwWl3fNYbPoX9jLZLHu5XQWiwV7ShzYPXbOusvu8Wr1TFaPEzN+s3j0bVnF6PFocQuj
	x+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAtygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM97sesRWcJyt4uKy
	p+wNjDtZuxg5OSQETCSOTP3DCGGLSVy4t56ti5GLQ0hgEaPEnnkdzBBOG5PEyak/wDrYBHQl
	nhy4DJYQEWhnlPi8dCszSIJZwE/i9p2ZYKOEBbwkPm64ARZnEVCV6J2wAczmFfCQ+PFyH9AK
	DqB1ChJzJtlMYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Pp5J7WBc2WBxiFGA
	g1GJh/dH+NUgIdbEsuLK3EOMEhzMSiK8TcLXgoR4UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqc
	D4zdvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgzN5zs+aK
	gr2pg3qPUdR5vg77V5J5IRMW2PgbXFvS/6SiILksJHl6W3JwHdsBvfKVSvcXrDGLTdl3Zd3m
	GzUVWVuXTxI1mVLc27uh+fTx+HkSl7v7Vs+Rjs3eFniq4fZ2J22W030TCpkuKpyyd5RjOxsZ
	9chvkdvmVv6Pz00XmtoYP1F5qb9JiaU4I9FQi7moOBEAzoOSUtMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the notifier_block name (i.e. foobar_cpu_notifer) is different from
the parameter (i.e.foobar_cpu_notifier) of register function, that is
definitely error and it also makes readers confused.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 Documentation/cpu-hotplug.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 8cb9938..be675d2 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -285,7 +285,7 @@ A: This is what you would need in your kernel code to receive notifications.
 		return NOTIFY_OK;
 	}
 
-	static struct notifier_block foobar_cpu_notifer =
+	static struct notifier_block foobar_cpu_notifier =
 	{
 	   .notifier_call = foobar_cpu_callback,
 	};
-- 
1.7.9.5

