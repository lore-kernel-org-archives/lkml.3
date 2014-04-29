Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaD2IQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:16:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43001 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaD2IP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:15:58 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-50-535f5fa8e952
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Michael Buesch'" <m@bues.ch>, "'Lokesh Vutla'" <lokeshvutla@ti.com>
Subject: [PATCH 1/2] hwrng: omap - remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:15:36 +0900
Message-id: <002201cf6383$3307d290$991777b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jgzLwkY90e/dFTi+TIinm6d8CaQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zA90V8fHBBg2ndSy6X8lYXF54idXi
	8q45bBYrOr4wWqya+4TVgdVj9vFHbB7bDqh69G1Zxehx/MZ2Jo/Pm+QCWKO4bFJSczLLUov0
	7RK4Ms6dOsFScJKtYuOtTewNjPtZuxg5OSQETCTmru2CssUkLtxbz9bFyMUhJLCMUWLlid1M
	MEWXtnwGs4UEFjFK7L1uDVH0m1Hi1/a7jCAJNgE1iS9fDrOD2CICehJ96xvB4swCnYwS969V
	gtjCAk4S3xZfAathEVCVWN7cBGbzCthKvPm9jRnCFpT4MfkeC0SvlsT6nceZIGx5ic1r3gLV
	cAAdpC7x6K8uiAmy6myXMkSFiMS+F+8YQU6TENjFLtE86TcjxCoBiW+TD7FAtMpKbDrADPGW
	pMTBFTdYJjCKzUKyeBaSxbOQLJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCEx
	N3EH4/0D1ocYk4HWT2SWEk3OB8ZsXkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwWmz5sGKvMutylfi9r0LyXwvo25WdZLF17PpTpnC8oePBn+8L
	2yYKCa95yBDYfOvEtBl6hvIPdEV0F/p6r9g788Q0R+EPP10+JGze1KrwR6s0WNPs75pWDRUj
	b3PZur9TYtkOs+6YueXz+S/q05dl23B7nP6w1lKt52zGt8TQiNn3NrAlu73Zo8RSnJFoqMVc
	VJwIAB5AitTPAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd0V8fHBBiefaVh0v5KxuLzwEqvF
	5V1z2CxWdHxhtFg19wmrA6vH7OOP2Dy2HVD16NuyitHj+I3tTB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWacO3WCpeAkW8XGW5vYGxj3s3YxcnJICJhIXNry
	mQnCFpO4cG89G4gtJLCIUWLvdesuRi4g+zejxK/tdxlBEmwCahJfvhxmB7FFBPQk+tY3gsWZ
	BToZJe5fqwSxhQWcJL4tvgJWwyKgKrG8uQnM5hWwlXjzexszhC0o8WPyPRaIXi2J9TuPM0HY
	8hKb17wFquEAOkhd4tFfXRATZNXZLmWIChGJfS/eMU5gFJiFZNAsJINmIRk0C0nLAkaWVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjBEf1MegfjqgaLQ4wCHIxKPLwdMXHBQqyJZcWVuYcY
	JTiYlUR4863ig4V4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5hs8kriDY1NzIwsjcwsjEzM
	zUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsVl0xdT3DO6JVjNzU26KPfu6nTFhY8An
	Fz0lSfaCgo4/pdM3C4g/+fsr9p3j5ft87voO+RLfo66fO3c4NHDC82msE8o9k46LxlUIdOpc
	2Luk78idF83Mk+O0ZUReMxU4vqy5YNlVcn/PnWX9VlOTJsvfmvAp4yG3rK/Ry6AD0hP55aWy
	HguFK7EUZyQaajEXFScCAGLjnkosAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/omap-rng.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 9b89ff4..f66ea25 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -369,10 +369,8 @@ static int omap_rng_probe(struct platform_device *pdev)
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(struct omap_rng_dev), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "could not allocate memory\n");
+	if (!priv)
 		return -ENOMEM;
-	};
 
 	omap_rng_ops.priv = (unsigned long)priv;
 	platform_set_drvdata(pdev, priv);
-- 
1.7.10.4


