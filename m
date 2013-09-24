Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3IXJPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:15:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22146 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3IXJP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:15:29 -0400
X-AuditID: cbfee68e-b7f756d000004512-86-524158300a90
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 13/22] backlight: gpio_backlight: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:15:28 +0900
Message-id: <005301ceb906$9c6944d0$d53bce70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAYZAw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI12DCMcgg2/79CzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErow7Lz6w
	FpzjqVh7YDt7A+Nxri5GTg4JAROJd+tusELYYhIX7q1n62Lk4hASWMYo8XDBDHaYooafyxgh
	EosYJe49/MUM4fxilGh/vYYRpIpNQE3iy5fDQB0cHCIC+hJtLRogYWaBHIn7T2aBDRISsJVY
	92E2mM0pYCdxaukZNhBbWCBC4nDfXRYQm0VAVeLctGlgF/EC1XdePAplC0r8mHyPBWKmlsTm
	bU2sELa8xOY1b5lB1koIqEs8+qsLcYGRRP+TIIgKEYl9L96BnS8hcIpdYnHnY6hVAhLfJh9i
	gWiVldh0gBniXUmJgytusExglJiFZPEsJItnIVk8C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL
	89L1kvNzNzFCYrJvB+PNA9aHGJOB1k9klhJNzgfGdF5JvKGxmZGFqYmpsZG5pRlpwkrivGot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJeZWFslyh3YEML9e0Vq9dwNL+a+er6Qg01+
	yT83U4H/8VMaVpy48q5v3qrnmxIqXU/Ul9nmpz2c+2jq5Hcif7q7Lx1rz3hdFbCJZQ/rzANq
	d7xaL0nu2bFPfqFF7ISqKT88/K6a3VXzmf/f/86WN0u2BnXaNM1XbhRbqevxeY1NzRq9H74r
	+TKVWIozEg21mIuKEwH5Tinr3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV2DCMcgg477WhZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGnRcfWAvO8VSsPbCdvYHxOFcXIyeHhICJRMPPZYwQtpjEhXvr
	2boYuTiEBBYxStx7+IsZwvnFKNH+eg1YFZuAmsSXL4fZuxg5OEQE9CXaWjRAwswCORL3n8xi
	B7GFBGwl1n2YDWZzCthJnFp6hg3EFhaIkDjcd5cFxGYRUJU4N20aK4jNC1TfefEolC0o8WPy
	PRaImVoSm7c1sULY8hKb17xlBlkrIaAu8eivLsQFRhL9T4IgKkQk9r14xziBUWgWkkGzkAya
	hWTQLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/wzqR2MKxssDjEKcDAq8fDu
	8HYIEmJNLCuuzD3EKMHBrCTCe8PWMUiINyWxsiq1KD++qDQntfgQYzLQnxOZpUST84HJKK8k
	3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGDOqbcITMzPln8zy
	Fcq807fvgkpW8oKCENlvdu2KnYFnhMpepnxjeB22vk89xEBh0zOH4x1mm46fqax57Gpuwzzx
	RAsjK1P8rgN807ezpGtLVh7U+XT5+RJx0S/t+Qf6ImatPSP13fmMV9GpfiVzR9mrB5Q+9Ekd
	2V94s6ZV3T0kJeUyz6WFSizFGYmGWsxFxYkA3uMxaTwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/gpio_backlight.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/gpio_backlight.c b/drivers/video/backlight/gpio_backlight.c
index 118da0c..81fb127 100644
--- a/drivers/video/backlight/gpio_backlight.c
+++ b/drivers/video/backlight/gpio_backlight.c
@@ -95,8 +95,9 @@ static int gpio_backlight_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 1;
-	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, gbl,
-				       &gpio_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, dev_name(&pdev->dev),
+					&pdev->dev, gbl, &gpio_backlight_ops,
+					&props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -109,21 +110,12 @@ static int gpio_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int gpio_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
-	return 0;
-}
-
 static struct platform_driver gpio_backlight_driver = {
 	.driver		= {
 		.name		= "gpio-backlight",
 		.owner		= THIS_MODULE,
 	},
 	.probe		= gpio_backlight_probe,
-	.remove		= gpio_backlight_remove,
 };
 
 module_platform_driver(gpio_backlight_driver);
-- 
1.7.10.4


