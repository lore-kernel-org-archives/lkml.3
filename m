Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3I3AuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:50:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16792 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3I3AuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:50:16 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ea-5248cac63298
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Subject: [PATCH V4 01/14] regulator: ab3100: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:50:14 +0900
Message-id: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ91jpzyCDH4/sLCY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEr48ONr2wFszgqPk7uZGpgfMXWxcjJISFgInFn0XQoW0ziwr31QDYXh5DAMkaJxY2z
	WWCKms8eYIFILGKUWPfoNzuE8wvIaVrDCFLFJqAm8eXLYaAEB4eIgKrE/1fuIDXMAjMZJXb2
	72ACiQsLeEl0PTICKWcBKtn+ZhlYK6+ArcTh5QdZIWxBiR+T74EtZhbQkli/8zgThC0vsXnN
	W2aQMRIC6hKP/uqChEUE9CSap19ghSgRkdj34h0jyFoJgUPsEovePmaD2CUg8W3yIRaIXlmJ
	TQeYIf6SlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85
	P3cTIyTyJuxgvHfA+hBjMtD6icxSosn5wMjNK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVANj/Pa4n3djvGQf86tOCvt1sLia0fZrVTNr0jLd/i8l
	MkI9X443rVSRU29tP77zzb+sSJlL/D1Lvh78lvWKj+XEDtYlIlMMyj/F8l2unmGlvi2y1T6s
	Ttvm5NGFiVzbFHbk8jV6Kgt3HTu2gEF9Gl+Z/DTdNetM0rYtU+KUPn7L+u/M0pkpnz8osRRn
	JBpqMRcVJwIAq2Ja3tICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd1jpzyCDJ78MrGY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePDja9sBbM4Kj5O7mRqYHzF1sXIySEhYCLR
	fPYAC4QtJnHh3nqgOBeHkMAiRol1j36zQzi/gJymNYwgVWwCahJfvhwGSnBwiAioSvx/5Q5S
	wywwk1FiZ/8OJpC4sICXRNcjI5ByFqCS7W+WgbXyCthKHF5+kBXCFpT4Mfke2GJmAS2J9TuP
	M0HY8hKb17xlBhkjIaAu8eivLkhYREBPonn6BVaIEhGJfS/eMU5gFJiFZNIsJJNmIZk0C0nL
	AkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBcf1MegfjqgaLQ4wCHIxKPLwWSz2ChFgT
	y4orcw8xSnAwK4nwLk8CCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MOXklcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjjoyJ1+2kgq7uy5WKB2vLEz/w
	C2l7d2ewy0w5bvtqSXdo+mv30GMtb2YbzX3L8fb6j8h7fi0/V9dXlFslP43ICFA1tnedXn44
	cDXfsRm3rr7eyvJBmH2Ompj1mbhO1iKR53xOtle9cl47pOfz7FjSmfbRs5Jr0eNvzet6n58V
	eMQy8cS5J9uVWIozEg21mIuKEwFF8ZOhLwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab3100.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 7d5eaa8..77b46d0 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -535,7 +535,7 @@ static int ab3100_regulator_register(struct platform_device *pdev,
 	config.dev = &pdev->dev;
 	config.driver_data = reg;
 
-	rdev = regulator_register(desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, desc, &config);
 	if (IS_ERR(rdev)) {
 		err = PTR_ERR(rdev);
 		dev_err(&pdev->dev,
@@ -616,7 +616,6 @@ static int ab3100_regulators_remove(struct platform_device *pdev)
 	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
 		struct ab3100_regulator *reg = &ab3100_regulators[i];
 
-		regulator_unregister(reg->rdev);
 		reg->rdev = NULL;
 	}
 	return 0;
-- 
1.7.10.4


