Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3JNIqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:46:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50803 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3JNIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:46:38 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-c2-525baf6d997f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 03/11] regulator: fixed: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:46:36 +0900
Message-id: <000201cec8b9$e47ceb60$ad76c220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAADe0g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA93c9dFBBvf3sVlMffiEzeLywkus
	Fkv3rWax+Halg8ni8q45bA6sHjtn3WX32LSqk82jt/kdm0ffllWMHp83yQWwRnHZpKTmZJal
	FunbJXBlrL33iqngFkfFo0UTWBsYu9i7GDk5JARMJFoOLoSyxSQu3FvPBmILCSxjlDh8IxOm
	5uaF7YxdjFxA8UWMEse//mKGcH4xSjz+cRmsg01ATeLLl8NAkzg4RARUJf6/cgepYRaYzihx
	duZ9doipthJ3T19iBrE5BewkFn7bxQJiCwPFz+/YATaHBaj395NWsDgvULx94gUmCFtQ4sfk
	e2BxZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETASOLl7bdQJSIS+168A3tAQuAWu8TL
	GT1MELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQX
	FCelFxnrFSfmFpfmpesl5+duYoREav8OxrsHrA8xJgOtn8gsJZqcD4z0vJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw5s6vuM69OOrjBcWPUvy/
	zDKNpkzpdOU7lZuvtuZKN59u8r3tprWZfM+OhDbI31bM8L7w4SHjxzOxS95pBDm+tKvf8fGz
	arG+mXulTjnz4Tlqj5xbTqvHVItJ3pm7U7wsuq7TYuHStObvEcr3tV9cY7FVPuk1da1U1jcb
	zf/N/UfYnG8tLNqvxFKckWioxVxUnAgALdGNS+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd3c9dFBBg/2MFlMffiEzeLywkus
	Fkv3rWax+Halg8ni8q45bA6sHjtn3WX32LSqk82jt/kdm0ffllWMHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZqy994qp4BZHxaNFE1gbGLvYuxg5OSQETCRu
	XtjOCGGLSVy4t56ti5GLQ0hgEaPE8a+/mCGcX4wSj39cZgOpYhNQk/jy5TBQNweHiICqxP9X
	7iA1zALTGSXOzrwPNlVIwFbi7ulLzCA2p4CdxMJvu1hAbGGg+PkdO8DmsAD1/n7SChbnBYq3
	T7zABGELSvyYfA8sziygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEm8vP0WqkREYt+L
	d4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCJ4Jr2D
	cVWDxSFGAQ5GJR5eAafoICHWxLLiytxDjBIczEoivILzgEK8KYmVValF+fFFpTmpxYcYk4Ee
	ncgsJZqcD0xSeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	uHzTb8ZJ85dOCor1N28+LKYqtdhCaWll3ltHkamZkcelYl2CehTiVKe/Mfh9Qznvd3S503X/
	kwovi7eu1Hs049MBWYlz7s172BVLYl9NOvCLaRfLk8QXsSecbDJ0rnPz/b3N78Ehtd+eeXYb
	Jyev98qUh3wOh1wD1RYWOiqtljv03mWfo4a/EktxRqKhFnNRcSIAUe25vUgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/fixed.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index de811f3..5ea64b9 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -168,17 +168,15 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		cfg.ena_gpio = config->gpio;
 	cfg.ena_gpio_invert = !config->enable_high;
 	if (config->enabled_at_boot) {
-		if (config->enable_high) {
+		if (config->enable_high)
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
-		} else {
+		else
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
-		}
 	} else {
-		if (config->enable_high) {
+		if (config->enable_high)
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
-		} else {
+		else
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
-		}
 	}
 	if (config->gpio_is_open_drain)
 		cfg.ena_gpio_flags |= GPIOF_OPEN_DRAIN;
-- 
1.7.10.4


