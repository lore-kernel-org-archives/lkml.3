Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaKLP2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:28:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25534 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaKLP2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:28:10 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-e2-54637c87a7a2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: max14577: Fix obvious typo in company name in copyright
Date: Wed, 12 Nov 2014 16:28:02 +0100
Message-id: <1415806082-19607-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xK7rtNckhBiuf8Fi8fmFocf/rUUaL
	y7vmsFmc7mZ1YPG4c20Pm8e8k4EefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlfH/eQ9LQR9r
	xcbdH9kaGGewdDFyckgImEjcXrmMDcIWk7hwbz2YLSSwlFFi/2HWLkYuILuPSWL9/91gCTYB
	Y4nNy5eA2SICWRI/pq0GG8QsYCjx890fdhBbWMBX4umSP6wgNouAqsS0/gWMIDavgLvEk2ln
	GCGWyUmcPDaZdQIj9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIX7/uoNx6TGrQ4wC
	HIxKPLwftJJDhFgTy4orcw8xSnAwK4nwTisBCvGmJFZWpRblxxeV5qQWH2Jk4uCUamC0ufLi
	1PPFX6SKvBy/WTu48a+4cWYr2+SfkcqCyWHRITc/xf5UsD5w6N3ftd+U1645GfDo4budD4ws
	ReV2aUgZVTwxjXz8nVu2qkMvY9PtiwsTNzE6hy29KMBqxHP20TcZg5mTDlTvc7yi0tHU8zs+
	Z8NnJu97p/9yNc7xnP1yrvf06kKdXz4CSizFGYmGWsxFxYkA4onWbdkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in name of company in copyright comment.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index de96b7fb1f6d..3bf8def82f1e 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -1,7 +1,7 @@
 /*
  * max14577.c - mfd core driver for the Maxim 14577/77836
  *
- * Copyright (C) 2014 Samsung Electrnoics
+ * Copyright (C) 2014 Samsung Electronics
  * Chanwoo Choi <cw00.choi@samsung.com>
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
-- 
1.9.1

