Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaIVXOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:14:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60700 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaIVXOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:14:07 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-86-5420ad3bc07d
Message-id: <5420AD3B.2080306@samsung.com>
Date: Tue, 23 Sep 2014 08:14:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] extcon: gpio: Convert the driver to use gpio desc API's
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
 <1410236078-11713-3-git-send-email-george.cherian@ti.com>
 <541FD8CD.1060400@samsung.com> <541FF138.7040908@ti.com>
In-reply-to: <541FF138.7040908@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkRNd6rUKIwcJL2hbzj5xjteh/s5DV
	4tTB5awWB/7sYLQ492olo8XlXXPYLJ4sPMNksfT6RSaL240r2CwmTF/LYtG69wi7xb4Lf1gd
	eDzWzFvD6HG5r5fJY9fOOaweK5d/YfPYtKqTzePOtT1sHju/N7B79G1Zxehx/MZ2Jo/Pm+QC
	uKK4bFJSczLLUov07RK4Mu4s2sxYsFyxou3WPpYGxvuSXYycHBICJhInrz9nh7DFJC7cW8/W
	xcjFISSwlFFi987djF2MHGBFzycXQcSnM0r8uL6aGaRBSOA1o8SSJWogNq+AlsSZwy8YQWwW
	AVWJw2vXgA1lA4rvf3GDDcQWFQiTWDn9CgtEvaDEj8n3wGwRoJr+S91MIAuYBSYxSWzb3geW
	EBYIkOjc8JgRYvMeRom9p1vBpnIKqEn0L58AZjML6Ejsb53GBmHLS2xe85YZpEFCYCaHxPLP
	69kgThKQ+Db5EAvEO7ISmw4wQ7wsKXFwxQ2WCYxis5AcNQvJ2FlIxi5gZF7FKJpakFxQnJRe
	ZKJXnJhbXJqXrpecn7uJERjdp/89m7CD8d4B60OMAhyMSjy8HmsUQoRYE8uKK3MPMZoCXTGR
	WUo0OR+YQvJK4g2NzYwsTE1MjY3MLc2UxHlfS/0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cC42nZekVmd28MdbvsnTpaxODhpluM3F4v8TVNqs2vLDFwYPj56aeeW/k8jNkz5e8zU/7d/
	OL6cd7KJT4Pd4sr3DYGTNvF+zU5dPr8z4K/vgmVKv75tcPQ8deb1r092a08/8tOSPtbpudZ/
	h/XHT59lhP/smtxh8UGiNfiq+NIjBdbvw1eufO3yVYmlOCPRUIu5qDgRACChdsrpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQV3rtQohBjuPKFnMP3KO1aL/zUJW
	i1MHl7NaHPizg9Hi3KuVjBaXd81hs3iy8AyTxdLrF5ksbjeuYLOYMH0ti0Xr3iPsFvsu/GF1
	4PFYM28No8flvl4mj10757B6rFz+hc1j06pONo871/aweez83sDu0bdlFaPH8RvbmTw+b5IL
	4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpc
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxZ9FmxoLlihVtt/axNDDe
	l+xi5OCQEDCReD65qIuRE8gUk7hwbz1bFyMXh5DAdEaJH9dXM4MkhAReM0osWaIGYvMKaEmc
	OfyCEcRmEVCVOLx2DTuIzQYU3//iBhuILSoQJrFy+hUWiHpBiR+T74HZIkA1/Ze6mUAWMAtM
	YpLYtr0PLCEsECDRueExI8TmPYwSe0+3gk3lFFCT6F8+AcxmFtCR2N86jQ3ClpfYvOYt8wRG
	gVlIlsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGp45nUDsaVDRaHGAU4
	GJV4eD3XKIQIsSaWFVfmHmKU4GBWEuEtmQgU4k1JrKxKLcqPLyrNSS0+xGgKDIOJzFKiyfnA
	tJZXEm9obGJmZGlkbmhhZGyuJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoEx6vv03/fud59R
	/LU1RDB7hvy83Pmf3lxb93pHx/Fd9pmfkk7oHFrn/Eujj0kuh/ePlbTU++17r545Ulm9xs/h
	qvC/XXKvuN2j2/0UI3QfScRaLosoTeBeLrTV3FvtdIMoQzSzH+OCHrsXK3/oerPW1nUos38R
	ffp5woyyE/9aBD7/3LLYgP+PEktxRqKhFnNRcSIAl1VnODMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 06:51 PM, George Cherian wrote:
> 
> On 09/22/2014 01:37 PM, Chanwoo Choi wrote:
>> Hi George,
>>
>> This patch removes 'gpio_active_low' field of struct gpio_extcon_data.
>> But, include/linux/extcon-gpio.h has the description of 'gpio_active_low' field.
> Yes didn't want the platform data users to break.
> Actually I couldn't find any platform users for this driver. Could you please point me to
> one if in case I missed it. If non present then why cant we get rid of platform data altogether.

Right,
But, Why do you support platform data on as following your patch?
- [PATCH 3/5] extcon: gpio: Add dt support for the driver.
According to your comment, you had to remove the support for platform data.

IMO,
I think this patchset must need to reorder the sequence of patchset.
Also, this patchset is more detailed description.

>>
>> Also,
>> This patch has not included the any description/comment of removing 'gpio_active_low'.
>>
>> Also,
>> How to set 'FLAG_ACTIVE_LOW' bit for gpio when using platform data?
> Now that we are using gpiod_* API's  we need not check for gpio_active_low from this driver.

This patch just use gpiod API instead of legacy gpio API.

I think that if extcon-gpio don't need to check gpio_activ_low field,
you have to implement dt support patch before this patch.

> 
>> This patch don't call 'set_bit()' function to set FLAG_ACTIVE_LOW flag.
>>
>> Thanks,
>> Chanwoo Choi
>>
>> On 09/09/2014 01:14 PM, George Cherian wrote:
>>> Convert the driver to use gpiod_* API's.
>>>
>>> Signed-off-by: George Cherian <george.cherian@ti.com>
>>> ---
>>>   drivers/extcon/extcon-gpio.c | 18 +++++++-----------
>>>   1 file changed, 7 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>>> index 72f19a3..25269f6 100644
>>> --- a/drivers/extcon/extcon-gpio.c
>>> +++ b/drivers/extcon/extcon-gpio.c
>>> @@ -33,8 +33,7 @@
>>>     struct gpio_extcon_data {
>>>       struct extcon_dev *edev;
>>> -    unsigned gpio;
>>> -    bool gpio_active_low;
>>> +    struct gpio_desc *gpiod;
>>>       const char *state_on;
>>>       const char *state_off;
>>>       int irq;
>>> @@ -50,9 +49,7 @@ static void gpio_extcon_work(struct work_struct *work)
>>>           container_of(to_delayed_work(work), struct gpio_extcon_data,
>>>                    work);
>>>   -    state = gpio_get_value(data->gpio);
>>> -    if (data->gpio_active_low)
>>> -        state = !state;
>>> +    state = gpiod_get_value(data->gpiod);
>>>       extcon_set_state(data->edev, state);
>>>   }
>>>   @@ -106,22 +103,21 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>>       }
>>>       extcon_data->edev->name = pdata->name;
>>>   -    extcon_data->gpio = pdata->gpio;
>>> -    extcon_data->gpio_active_low = pdata->gpio_active_low;
>>> +    extcon_data->gpiod = gpio_to_desc(pdata->gpio);
>>>       extcon_data->state_on = pdata->state_on;
>>>       extcon_data->state_off = pdata->state_off;
>>>       extcon_data->check_on_resume = pdata->check_on_resume;
>>>       if (pdata->state_on && pdata->state_off)
>>>           extcon_data->edev->print_state = extcon_gpio_print_state;
>>>   -    ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
>>> +    ret = devm_gpio_request_one(&pdev->dev, pdata->gpio, GPIOF_DIR_IN,
>>>                       pdev->name);
>>>       if (ret < 0)
>>>           return ret;
>>>         if (pdata->debounce) {
>>> -        ret = gpio_set_debounce(extcon_data->gpio,
>>> -                    pdata->debounce * 1000);
>>> +        ret = gpiod_set_debounce(extcon_data->gpiod,
>>> +                     pdata->debounce * 1000);
>>>           if (ret < 0)
>>>               extcon_data->debounce_jiffies =
>>>                   msecs_to_jiffies(pdata->debounce);
>>> @@ -133,7 +129,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>>         INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>>>   -    extcon_data->irq = gpio_to_irq(extcon_data->gpio);
>>> +    extcon_data->irq = gpiod_to_irq(extcon_data->gpiod);
>>>       if (extcon_data->irq < 0)
>>>           return extcon_data->irq;
>>>  
> 
> 

