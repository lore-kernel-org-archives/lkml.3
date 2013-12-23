Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3LWGe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:34:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51561 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3LWGez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:34:55 -0500
X-AuditID: cbfee68f-b7f156d00000276c-84-52b7d98df361
Message-id: <52B7D990.2020206@samsung.com>
Date: Mon, 23 Dec 2013 15:34:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Barry Song <21cnbao@gmail.com>
Cc: rjying <rjying@gmail.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>
Subject: Re: [PATCH 1/1] extcon: gpio: Add power resume support
References: <1387526987-12455-1-git-send-email-rongjun.ying@csr.com>
 <52B7B9F0.1020801@samsung.com>
 <CAGsJ_4xwc63kEBgmMk+E3JpYLhX0Vt1qQPcBXNtOGC2Gmo=MOw@mail.gmail.com>
In-reply-to: <CAGsJ_4xwc63kEBgmMk+E3JpYLhX0Vt1qQPcBXNtOGC2Gmo=MOw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkWLf35vYgg8MLTSw+3xWyaGjYwWhx
	edccNovbjSvYLG71HmC22HfhD6sDm8eunXNYPXbOusvu0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBmbl01gKpgsWfFo2S+2Bsbbwl2MnBwSAiYS33/fYYOwxSQu3FsPZHNxCAksZZTYe+8b
	excjB1jR7uu2EPFFjBLfrz5mgnBeMUqs+NjPAtLNK6AlcexXNzOIzSKgKrF231F2EJsNKL7/
	xQ2wDaICYRIrp1+BqheU+DH5HpgtIqAkMXnqNxaQocwCOxkl9t/dygqSEBawl1j5cREjxLY1
	jBJz3s0Fm8QpECyx9tdbJhCbWUBdYtK8RcwQtrzE5jVvmUEaJASOsUt8PPCeCeIkAYlvkw+x
	QPwjK7HpADPEz5ISB1fcYJnAKDYLyVGzkIydhWTsAkbmVYyiqQXJBcVJ6UXGesWJucWleel6
	yfm5mxiBUXb637P+HYx3D1gfYkwGWjmRWUo0OR8YpXkl8YbGZkYWpiamxkbmlmakCSuJ895/
	mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZGjJ/fcifs7Jh6IvlHMs++4p17XEfaU6ltm
	9pXlOZs2vWZUM976il9w90zX24wt/twPju76WHyy4rHsze17j9ffX62vyTCjU7/i4Tlu7xVf
	32m/bNWrfFWXyb214fTf0NVqDVUXp2V5MnlMiVdqXmxw1uL6hICIyE9Hs5t46qV35zyxdIuQ
	NVJiKc5INNRiLipOBAAKXRJ6yAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd3em9uDDCZ0alh8vitk0dCwg9Hi
	8q45bBa3G1ewWdzqPcBsse/CH1YHNo9dO+eweuycdZfdo2/LKkaPz5vkAliiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzNi+bwFQwWbLi0bJfbA2Mt4W7GDk4JARMJHZf
	t+1i5AQyxSQu3FvP1sXIxSEksIhR4vvVx0wQzitGiRUf+1lAqngFtCSO/epmBrFZBFQl1u47
	yg5iswHF97+4wQZiiwqESaycfgWqXlDix+R7YLaIgJLE5KnfWECGMgvsZJTYf3crK0hCWMBe
	YuXHRYwQ29YwSsx5NxdsEqdAsMTaX2+ZQGxmAXWJSfMWMUPY8hKb17xlnsAoMAvJkllIymYh
	KVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziGn0nvYFzVYHGIUYCDUYmHl6Nle5AQ
	a2JZcWXuIUYJDmYlEd7oH9uChHhTEiurUovy44tKc1KLDzEmA8NgIrOUaHI+ML3klcQbGpuY
	GVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjnaZaFuvC9vz0JtN/y1as
	+PI8/pb3vvCsKzePCq/5sHzK4dNTX+sfVwr28ZurHXHy5UbdthuR748xzuveXWMcmC2T8KBU
	9ZPhT611l4peuF+/puDncnyOQJNt8ft/X1+/NDqqVvv858ZzMmm/vgVMNsm9+Sz084Lch1fz
	69/XdW6I3Ll0+zGZh0osxRmJhlrMRcWJAGtrC/AlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 03:10 PM, Barry Song wrote:
> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>> On 12/20/2013 05:09 PM, rjying wrote:
>>> From: Rongjun Ying <rongjun.ying@csr.com>
>>>
>>> After system resume, need send extcon uevent to userspace
>>
>> Why did extcon send uevent after wakeup from suspend?
>>
>> If extcon cable is attatched or detached on suspend state,
>> Kernel can detect the interrupt about changed state of extcon.
> 
> irq controller has lost power in suspend, so there is no pending interrupt.
> and HW will not pend any interrupt when we hotplug cable during sleep.

No, SoC in suspend state must maintain the minimum power under 1mA 
if completed the power-optimization on suspend state.

If user insert USB cable to target, the external interrupt connected to 
USB port is happened. And kernel would be waked up from suspend state 
to operate proper interrupt handler of external interrupt.

Also,
Input subsystem used gpio-keys driver for power button..
If user press power button in suspend state, target would be waked up from suspend state.
It is same case both extcon gpio and gpio-keys of input subsystem.

> 
>> So, kernel would execute proper operation about interrupt
>> after wakeup from suspend state.
> 
> kernel only save/restore the register status of gpio, how could it
> know whether there is a pending interrupt if the HW doesn't do it?
> 
>>
>> I think it isn't necessary.
>>
>> Thanks,
>> Chanwoo Choi
>>
>>>
>>> Change-Id: I32a9e1c6646035f95765bba79a7acaccb8ce45a7
>>>
>>> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
>>> ---
>>>  drivers/extcon/extcon-gpio.c |   17 +++++++++++++++++
>>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>>> index 7e0dff5..d916522 100644
>>> --- a/drivers/extcon/extcon-gpio.c
>>> +++ b/drivers/extcon/extcon-gpio.c
>>> @@ -159,12 +159,29 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>>>       return 0;
>>>  }
>>>
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int gpio_extcon_resume(struct device *dev)
>>> +{
>>> +     struct gpio_extcon_data *extcon_data;
>>> +
>>> +     extcon_data = dev_get_drvdata(dev);
>>> +     queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
>>> +                           extcon_data->debounce_jiffies);
>>> +     return 0;
>>> +}
>>> +#endif
>>> +
>>> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
>>> +     SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
>>> +};
>>> +
>>>  static struct platform_driver gpio_extcon_driver = {
>>>       .probe          = gpio_extcon_probe,
>>>       .remove         = gpio_extcon_remove,
>>>       .driver         = {
>>>               .name   = "extcon-gpio",
>>>               .owner  = THIS_MODULE,
>>> +             .pm = &gpio_extcon_pm_ops,
>>>       },
>>>  };
>>>
>>>
>>
> 
> -barry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

