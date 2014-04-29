Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaD2IQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:16:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43203 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaD2IQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:16:44 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-1d-535f5feb8d03
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Alexander Clouter'" <alex@digriz.org.uk>
References: <002201cf6383$3307d290$991777b0$%han@samsung.com>
In-reply-to: <002201cf6383$3307d290$991777b0$%han@samsung.com>
Subject: [PATCH 2/2] hwrng: timeriomem - remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:16:42 +0900
Message-id: <002301cf6383$5aab8710$10029530$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jgzLwkY90e/dFTi+TIinm6d8CaQAAAgJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zQ93X8fHBBo0TJC06mkMsul/JWFxe
	eInV4vKuOWwOLB7r5s1l89h2QNWjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mk6vO8xUMIu9
	4shr4wbGDrYuRk4OCQETiS1bP7ND2GISF+6tB4pzcQgJLGOU+NX3jRWmaM+Xz1CJRYwS8y/c
	YYdwfjNKvHr8AWwUm4CaxJcvh8FGiQjoSfStb2QEsZkFCiQWHHvKAmILCdhKLJq+jgnE5hSw
	k/ix6TMziC0s4CHx8P91oG0cHCwCqhKnZuWChHmByqfu2s8EYQtK/Jh8jwVipJbE+p3HmSBs
	eYnNa94yg7RKCKhLPPqrC3GBkcTiHT1sECUiEvtevGMEOVlC4Bi7xIPH78DmsAgISHybfIgF
	oldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7N
	S9dLzs/dxAiJxv4djHcPWB9iTAZaP5FZSjQ5HxjNeSXxhsZmRhamJqbGRuaWZqQJK4nz3n+Y
	FCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcfeyCiv1a3/+tb3zlznw7qTrjObER3JCGh4H
	xPj2aKzb+3F5cfL16+ySTqb7Fx9a47O0gbP716fudet4mRcZ3g9KXPrCR2uXn1iuefrz3PIq
	w6czvtdve3y0Ip81rC6rf++9ycEsLvN+Kl28/SPks92cz5tFjSO3dtUmiz34q7lizqGYRK2n
	qUosxRmJhlrMRcWJAJRjduncAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd3X8fHBBg0LRS06mkMsul/JWFxe
	eInV4vKuOWwOLB7r5s1l89h2QNWjb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYqKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM
	0PUNCYLrMTJAAwnrGDNOrzvMVDCLveLIa+MGxg62LkZODgkBE4k9Xz5D2WISF+6tB7K5OIQE
	FjFKzL9whx3C+c0o8erxB7AqNgE1iS9fDrOD2CICehJ96xsZQWxmgQKJBceesoDYQgK2Eoum
	r2MCsTkF7CR+bPrMDGILC3hIPPx/nbWLkYODRUBV4tSsXJAwL1D51F37mSBsQYkfk++xQIzU
	kli/8zgThC0vsXnNW2aQVgkBdYlHf3UhLjCSWLyjhw2iRERi34t3jBMYhWYhmTQLyaRZSCbN
	QtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwrD+T2sG4ssHiEKMAB6MSD69BVFyw
	EGtiWXFl7iFGCQ5mJRHefKv4YCHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OB6ahvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgdL87XadV7LvYJ5FDTTMW
	TSl/fEuU8brenlXr4oKm/rJP+dzPLxI7uSw153D0i6uvXZxdLXasvO5ax2bC++eJ461jC8+0
	X5vwTUWi5b2VuWdl47KE7U9udjxdEuxdvu377QcHC+sFZrCJ7Lnt4SC7KD7Ok3XmMv6IHUcu
	5X9wWlS3MWdnuJDYfiWW4oxEQy3mouJEAMQAQL05AwAA
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
 drivers/char/hw_random/timeriomem-rng.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 439ff8b..b6ab9ac 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -120,10 +120,8 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	/* Allocate memory for the device structure (and zero it) */
 	priv = devm_kzalloc(&pdev->dev,
 			sizeof(struct timeriomem_rng_private_data), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "failed to allocate device structure.\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, priv);
 
-- 
1.7.10.4


