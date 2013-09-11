Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3IKCD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:03:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22832 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3IKCD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:03:57 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-9b-522fcf8b3bd2
Message-id: <522FCF8C.9040205@samsung.com>
Date: Wed, 11 Sep 2013 11:03:56 +0900
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
 <522FC476.7060100@samsung.com> <522FCE08.5000704@roeck-us.net>
In-reply-to: <522FCE08.5000704@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkSLf7vH6QQcsaLYv5R86xWhz4s4PR
	4k1vB4vF5V1z2CyeLDzDZLH0+kUmi9uNK9gsJkxfy2JxeMUBJotXB9tYHLg81sxbw+ix4PMV
	do/Xkycwety5tofNY+f3BnaPvi2rGD0+b5Lz2Dg3NIAjissmJTUnsyy1SN8ugSujve8xe8E+
	5YqXK68zNzAekupi5OSQEDCRuNG0kh3CFpO4cG89WxcjF4eQwFJGiRl39zHDFL2cfZ8RIjGd
	UeL2uk5WCOcVo8SC3y1AGQ4OXgEtiU/LLEAaWARUJZ41vmAEsdmAwvtf3GADsUUFwiRWTr/C
	AmLzCghK/Jh8D8wWEVCTaD7VAraZWeASk0Trp7VgCWGBSImZ555CLdvDKHFoxRmwBKeAjsT7
	jqNg5zED2ftbp7FB2PISm9e8ZQZpkBD4yS7RMvUPI8RJAhLfJh9iAblUQkBWYtMBqNckJQ6u
	uMEygVFsFpKjZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAqP29L9nE3cw
	3j9gfYgxGWjlRGYp0eR8YNTnlcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoHxpJy2euOybfM3VfiK73875WnTvX9pf0re9Vr1/ov1mXny5AobuU+3
	2OK4BJp4ZdqqU1W+XTER1KjYt99xe2PnSf4Xv7YL6kk4Vbwx/v9z+tvT/6pO/pxx44r706Td
	iS4MLIxNfy4Lp91d0HXeeHYrv/DDX1JmImc7qszfphw8atzQx5x3Y9liJZbijERDLeai4kQA
	l399q/ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd3u8/pBBleuKlrMP3KO1eLAnx2M
	Fm96O1gsLu+aw2bxZOEZJoul1y8yWdxuXMFmMWH6WhaLwysOMFm8OtjG4sDlsWbeGkaPBZ+v
	sHu8njyB0ePOtT1sHju/N7B79G1ZxejxeZOcx8a5oQEcUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM9r7HrMX7FOueLnyOnMD4yGpLkZODgkBE4mXs+8zQthiEhfurWfr
	YuTiEBKYzihxe10nK4TzilFiwe8WoCoODl4BLYlPyyxAGlgEVCWeNb4Aa2YDCu9/cYMNxBYV
	CJNYOf0KC4jNKyAo8WPyPTBbREBNovlUC9gCZoFLTBKtn9aCJYQFIiVmnnsKtWwPo8ShFWfA
	EpwCOhLvO44yg9jMQPb+1mlsELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQITgnPpHYwrmywOMQowMGoxMN7Q04/SIg1say4MvcQowQHs5II71Qn
	oBBvSmJlVWpRfnxRaU5q8SHGZGAYTGSWEk3OB6arvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7Ra
	BwoJpCeWpGanphakFsFsYeLglGpgXJovYcbL5jBtjoHlxHdGnjWP9ugoz64vPr8houB17Yrr
	87OcfL9ZGph99Og4ZSDDdmXST6b3wcadnJnVdZbVri1t6ROXByU1tu2T3f183bH80N6r75YE
	bDsdMPvD3FR5n+jlzPwHZld7GL5rt/B8NDPEoGH/9yvWgv9uvv6o8a2O67thrfdDJZbijERD
	Leai4kQAfHmVGU0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 10:57 AM, Guenter Roeck wrote:
> On 09/10/2013 06:16 PM, Chanwoo Choi wrote:
>> Hi Guenter
>>
>> I agree to use gpio_set_debounce() API but, I suggest following patch to code clean.
>> and I'd like you to use declarative sentence on patch name instead of 'If ...'.
>>
>> On 08/30/2013 01:29 PM, Guenter Roeck wrote:
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>>   drivers/extcon/extcon-gpio.c |    5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>>> index 77d35a7..973600e 100644
>>> --- a/drivers/extcon/extcon-gpio.c
>>> +++ b/drivers/extcon/extcon-gpio.c
>>> @@ -111,6 +111,11 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>>       if (ret < 0)
>>>           goto err;
>>>
>>> +    /* Use gpio debounce if available. If so, don't debounce in software. */
>>> +    if (pdata->debounce &&
>>> +        !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
>>> +        extcon_data->debounce_jiffies = 0;
>>> +
>>>       INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>>>
>>>       extcon_data->irq = gpio_to_irq(extcon_data->gpio);
>>>
>>
>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>> index 3943ce2..0777e72 100644
>> --- a/drivers/extcon/extcon-gpio.c
>> +++ b/drivers/extcon/extcon-gpio.c
>> @@ -56,8 +56,10 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
>>   {
>>          struct gpio_extcon_data *extcon_data = dev_id;
>>
>> -       queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
>> -                             extcon_data->debounce_jiffies);
>> +       if (extcon_data->debounce_jiffies)
>> +               queue_delayed_work(system_power_efficient_wq,
>> +                                  &extcon_data->work,
>> +                                  extcon_data->debounce_jiffies);
> 
> I am a bit lost about this one. The above means that the workqueue would not be executed
> at all if debounce_jiffies is 0 (and if pdata->debounce is 0), meaning an event would
> never be generated. With the original code, the workqueue will be executed immediately
> if debounce_jiffies is 0, which I think is exactly what we need.
> 
>>          return IRQ_HANDLED;
>>   }
>>
>> @@ -100,7 +102,14 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>          extcon_data->state_off = pdata->state_off;
>>          if (pdata->state_on && pdata->state_off)
>>                  extcon_data->edev.print_state = extcon_gpio_print_state;
>> -       extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
>> +       extcon_data->debounce_jiffies = 0;
>> +       if (pdata->debounce) {
>> +               ret = gpio_set_debounce(extcon_data->gpio,
>> +                                       pdata->debounce * 1000);
>> +               if (ret < 0)
>> +                       extcon_data->debounce_jiffies =
>> +                               msecs_to_jiffies(pdata->debounce);
>> +       }
>>
> Ok, though it is unnecessary to initialize debounce_jiffies (it is pre-initialized
> from the allocation), so I'll drop that line.

OK.

> 
>>          ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
>>          if (ret < 0)
>> @@ -111,11 +120,6 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>          if (ret < 0)
>>                  goto err;
>>
>> -       /* Use gpio debounce if available. If so, don't debounce in software. */
>> -       if (pdata->debounce &&
>> -           !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
>> -               extcon_data->debounce_jiffies = 0;
>> -
>>          INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>>
>>          extcon_data->irq = gpio_to_irq(extcon_data->gpio);
>> @@ -146,7 +150,8 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>>   {
>>          struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
>>
>> -       cancel_delayed_work_sync(&extcon_data->work);
>> +       if (extcon_data->debounce_jiffies)
>> +               cancel_delayed_work_sync(&extcon_data->work);
> 
> I think we would have to call cancel_work_sync() in the else case to make sure
> that no work is in the process of being executed - which just turns out to execute
> the same code as cancel_delayed_work_sync(). So the if/else would just add complexity
> with no real gain.

OK.

Thanks,
Chanwoo Choi

