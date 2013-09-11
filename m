Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3IKBQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:16:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13097 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3IKBQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:16:39 -0400
X-AuditID: cbfee68e-b7f756d000004512-1a-522fc47546ef
Message-id: <522FC476.7060100@samsung.com>
Date: Wed, 11 Sep 2013 10:16:38 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/6] extcon-gpio: If the gpio driver/chip supports
 debounce, use it
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-3-git-send-email-linux@roeck-us.net>
In-reply-to: <1377836978-24082-3-git-send-email-linux@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkRLf0iH6Qwbofehbzj5xjtTjwZwej
	xZveDhaLy7vmsFk8WXiGyWLp9YtMFrcbV7BZTJi+lsXi8IoDTBavDraxOHB5rJm3htFjwecr
	7B6vJ09g9LhzbQ+bx87vDewefVtWMXp83iTnsXFuaABHFJdNSmpOZllqkb5dAlfGllW7GAt2
	S1ccarNpYNwt0sXIySEhYCLx89I9JghbTOLCvfVsXYxcHEICSxkl7n/ZC5TgACvassMbpEZI
	YBGjxL1Z1hA1rxglrv/6A9bMK6Al8XLrbhaQehYBVYl5IHM4OdiAwvtf3ACzRQXCJFZOv8IC
	US4o8WPyPTBbREBNovlUC9heZoFLTBKtn9aCJYQFIiVmnnvKCrG4WqKt/T07iM0p4Czx7vxK
	MJtZQEdif+s0NghbXmLzmrfMIIMkBL6ySyyZ+xZsEIuAgMS3yYdYIJ6Rldh0gBniYUmJgytu
	sExgFJuF5KZZSMbOQjJ2ASPzKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzAaD3971nfDsab
	B6wPMSYDrZzILCWanA+M9rySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MIpZisa6vH7TMFv1QMR+m8q1r3gCYsUXCiotcj4j+jp5ia8QQ0fkhHe7
	jrp3L3r4ckFi3UFWRWMW64hIzRn8zxZsmcg/m2n73tY55r8X3r8pPIuPTVv+/gyOWuulSVMO
	toQbsOQ6FIl+ZfxZNWX3BB+HAxwSBVO+8b5Y9XWflfO0nwGF3vsFvyqxFGckGmoxFxUnAgDW
	Aoqs7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd3SI/pBBju+qFrMP3KO1eLAnx2M
	Fm96O1gsLu+aw2bxZOEZJoul1y8yWdxuXMFmMWH6WhaLwysOMFm8OtjG4sDlsWbeGkaPBZ+v
	sHu8njyB0ePOtT1sHju/N7B79G1ZxejxeZOcx8a5oQEcUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM7as2sVYsFu64lCbTQPjbpEuRg4OCQETiS07vLsYOYFMMYkL99az
	gdhCAosYJe7Nsu5i5AKyXzFKXP/1hwkkwSugJfFy624WkF4WAVWJeRD1bEDh/S9ugNmiAmES
	K6dfYYEoF5T4MfkemC0ioCbRfKqFDWQms8AlJonWT2vBEsICkRIzzz1lhVhcLdHW/p4dxOYU
	cJZ4d34lmM0soCOxv3UaG4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxglPBM6kdjCsbLA4xCnAwKvHw3pDTDxJiTSwrrsw9xCjBwawkwjvVCSjE
	m5JYWZValB9fVJqTWnyIMRkYAhOZpUST84FpKq8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGLP3R73cWivG9Ts2MVfkSuv1JUUhs3KLnrdzGiVpvpZ7LuDi
	eIhtXWUg7+PKifG9TX+fJFjt316xwOe0m53TFWuR667TnzgorpBiKl01a/qDfSfWrJLzyz2S
	+eC77lcnS/fmNd/4TTIn1jZU2/Y718qkLBLJEJl2c7PzTxVFD/dlC+81VSmZKbEUZyQaajEX
	FScCAF1d0KRJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter

I agree to use gpio_set_debounce() API but, I suggest following patch to code clean.
and I'd like you to use declarative sentence on patch name instead of 'If ...'.

On 08/30/2013 01:29 PM, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/extcon/extcon-gpio.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 77d35a7..973600e 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -111,6 +111,11 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err;
>  
> +	/* Use gpio debounce if available. If so, don't debounce in software. */
> +	if (pdata->debounce &&
> +	    !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
> +		extcon_data->debounce_jiffies = 0;
> +
>  	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>  
>  	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
> 

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 3943ce2..0777e72 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -56,8 +56,10 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
 {
        struct gpio_extcon_data *extcon_data = dev_id;
 
-       queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
-                             extcon_data->debounce_jiffies);
+       if (extcon_data->debounce_jiffies)
+               queue_delayed_work(system_power_efficient_wq,
+                                  &extcon_data->work,
+                                  extcon_data->debounce_jiffies);
        return IRQ_HANDLED;
 }
 
@@ -100,7 +102,14 @@ static int gpio_extcon_probe(struct platform_device *pdev)
        extcon_data->state_off = pdata->state_off;
        if (pdata->state_on && pdata->state_off)
                extcon_data->edev.print_state = extcon_gpio_print_state;
-       extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
+       extcon_data->debounce_jiffies = 0;
+       if (pdata->debounce) {
+               ret = gpio_set_debounce(extcon_data->gpio,
+                                       pdata->debounce * 1000);
+               if (ret < 0)
+                       extcon_data->debounce_jiffies =
+                               msecs_to_jiffies(pdata->debounce);
+       }
 
        ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
        if (ret < 0)
@@ -111,11 +120,6 @@ static int gpio_extcon_probe(struct platform_device *pdev)
        if (ret < 0)
                goto err;
 
-       /* Use gpio debounce if available. If so, don't debounce in software. */
-       if (pdata->debounce &&
-           !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
-               extcon_data->debounce_jiffies = 0;
-
        INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
        extcon_data->irq = gpio_to_irq(extcon_data->gpio);
@@ -146,7 +150,8 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 {
        struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
 
-       cancel_delayed_work_sync(&extcon_data->work);
+       if (extcon_data->debounce_jiffies)
+               cancel_delayed_work_sync(&extcon_data->work);
        free_irq(extcon_data->irq, extcon_data);
        extcon_dev_unregister(&extcon_data->edev);


Thanks,
Chanwoo Choi
