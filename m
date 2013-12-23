Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3LWH4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 02:56:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11425 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 02:56:54 -0500
X-AuditID: cbfee68f-b7f156d00000276c-0a-52b7ecc4ee6f
Message-id: <52B7ECC7.8020508@samsung.com>
Date: Mon, 23 Dec 2013 16:56:55 +0900
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
 <52B7D990.2020206@samsung.com>
 <CAGsJ_4wbYkadoM5HHwbGUcwuimxiq-u9FMaWMs7wD-SXU4ybcQ@mail.gmail.com>
In-reply-to: <CAGsJ_4wbYkadoM5HHwbGUcwuimxiq-u9FMaWMs7wD-SXU4ybcQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkRPfIm+1BBtc/Kll8vitk0dCwg9Hi
	8q45bBa3G1ewWdzqPcBsse/CH1YHNo9dO+eweuycdZfdo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDKOzZ/CWnBMsWLW5xVsDYzHpLoYOTkkBEwk7p/6wA5hi0lcuLeerYuRi0NIYCmjxIGX
	vxhhim60PIJKLGKU6Hy1iRnCecUoceznW1aQKl4BLYmjdx+wgdgsAqoSPz6fZgGx2YDi+1/c
	AIuLCoRJrJx+hQWiXlDix+R7YLaIgJLE5KnfWECGMgvsZJTYf3cr2FBhAXuJlR8XMUJsm8Ik
	Mf3Qb7BJnALBEteuTAO7j1lAXWLSvEXMELa8xOY1b8HOkxDYxy4xo6GbGeIkAYlvkw8BreAA
	SshKbDrADPGbpMTBFTdYJjCKzUJy1CwkY2chGbuAkXkVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRmCcnf73rH8H490D1ocYk4FWTmSWEk3OB8ZpXkm8obGZkYWpiamxkbmlGWnCSuK89x8m
	BQkJpCeWpGanphakFsUXleakFh9iZOLglGpgnPHAoXvpAv/ePZpKy05//V/8b/GyIzLZxzcd
	dFSrfvpR9E3ONq9q8UNyD17GPnWbe22nxdeJGuc/dLNp9peZnbeINHk4V34Dhx7/50eSSz1D
	61tO1E/pelKaYsXpJLnh0+EAwxftyaoBZc13S6SdBZlUvnJGPWJka7Sa8LthG9Na00RV81eP
	lFiKMxINtZiLihMBGg8q5ckCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd0jb7YHGZzdLm3x+a6QRUPDDkaL
	y7vmsFncblzBZnGr9wCzxb4Lf1gd2Dx27ZzD6rFz1l12j74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMODZ/CmvBMcWKWZ9XsDUwHpPqYuTkkBAwkbjR
	8ogNwhaTuHBvPZDNxSEksIhRovPVJmYI5xWjxLGfb1lBqngFtCSO3n0A1sEioCrx4/NpFhCb
	DSi+/8UNsLioQJjEyulXWCDqBSV+TL4HZosIKElMnvqNBWQos8BORon9d7eCDRUWsJdY+XER
	I8S2KUwS0w/9BpvEKRAsce3KNEYQm1lAXWLSvEXMELa8xOY1b5knMArMQrJkFpKyWUjKFjAy
	r2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjuJn0jsYVzVYHGIU4GBU4uHlaNkeJMSaWFZc
	mXuIUYKDWUmEN/rHtiAh3pTEyqrUovz4otKc1OJDjMnAMJjILCWanA9MMHkl8YbGJmZGlkbm
	hhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwOg6l31GKesEoweLPpTYrWoLbrj6
	/5aw5eKHSnyHDlw31y/Vu5t7cfvrNdlKVqmLjQ5qTvEO3exgY/Cp0ljU46Or2TlxRn9fuyfx
	mhwpgmmssRF1mzzvHl10Vev9/Xy+jfP4dewLdtiW90cLmglV3Os1OFPa6VHNaOhyINR1VZGV
	/WZt0Z2/lFiKMxINtZiLihMBXmOzxiYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 04:36 PM, Barry Song wrote:
> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>> On 12/23/2013 03:10 PM, Barry Song wrote:
>>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>>>> On 12/20/2013 05:09 PM, rjying wrote:
>>>>> From: Rongjun Ying <rongjun.ying@csr.com>
>>>>>
>>>>> After system resume, need send extcon uevent to userspace
>>>>
>>>> Why did extcon send uevent after wakeup from suspend?
>>>>
>>>> If extcon cable is attatched or detached on suspend state,
>>>> Kernel can detect the interrupt about changed state of extcon.
>>>
>>> irq controller has lost power in suspend, so there is no pending interrupt.
>>> and HW will not pend any interrupt when we hotplug cable during sleep.
>>
>> No, SoC in suspend state must maintain the minimum power under 1mA
>> if completed the power-optimization on suspend state.
>>
>> If user insert USB cable to target, the external interrupt connected to
>> USB port is happened. And kernel would be waked up from suspend state
>> to operate proper interrupt handler of external interrupt.
> 
> no. not every USB supports that. that depends on the power domain design of SoC.

USB is only example for gpio control in suspend state.

> 
>>
>> Also,
>> Input subsystem used gpio-keys driver for power button..
>> If user press power button in suspend state, target would be waked up from suspend state.
>> It is same case both extcon gpio and gpio-keys of input subsystem.
> 
> no. it depends on the SoC design. many SoC only support 1 special key
> which can work as ON-KEY as wakeup source. and this kind of keys might
> not be GPIO at all.
> there is a special power domain which is still open for it.

many SoC? 

As I knew, most SoC has supported various wakeup source.
As you comment, if specific SoC support only one special key
for wakeup from suspend state, I think it isn't common.

Also,
This patch isn't necessary on SoCs which support various wakeup source (e.g., external interrupt).
As you comment, this issue has dependecy on specific SoC. Why did you think this common code?

> 
>>
>>>
>>>> So, kernel would execute proper operation about interrupt
>>>> after wakeup from suspend state.
>>>
>>> kernel only save/restore the register status of gpio, how could it
>>> know whether there is a pending interrupt if the HW doesn't do it?
>>>
>>>>
>>>> I think it isn't necessary.
>>>>
>>>> Thanks,
>>>> Chanwoo Choi
>>>>
>>>>>
>>>>> Change-Id: I32a9e1c6646035f95765bba79a7acaccb8ce45a7
>>>>>
>>>>> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
>>>>> ---
>>>>>  drivers/extcon/extcon-gpio.c |   17 +++++++++++++++++
>>>>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>>>>> index 7e0dff5..d916522 100644
>>>>> --- a/drivers/extcon/extcon-gpio.c
>>>>> +++ b/drivers/extcon/extcon-gpio.c
>>>>> @@ -159,12 +159,29 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>>>>>       return 0;
>>>>>  }
>>>>>
>>>>> +#ifdef CONFIG_PM_SLEEP
>>>>> +static int gpio_extcon_resume(struct device *dev)
>>>>> +{
>>>>> +     struct gpio_extcon_data *extcon_data;
>>>>> +
>>>>> +     extcon_data = dev_get_drvdata(dev);
>>>>> +     queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
>>>>> +                           extcon_data->debounce_jiffies);
>>>>> +     return 0;
>>>>> +}
>>>>> +#endif
>>>>> +
>>>>> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
>>>>> +     SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
>>>>> +};
>>>>> +
>>>>>  static struct platform_driver gpio_extcon_driver = {
>>>>>       .probe          = gpio_extcon_probe,
>>>>>       .remove         = gpio_extcon_remove,
>>>>>       .driver         = {
>>>>>               .name   = "extcon-gpio",
>>>>>               .owner  = THIS_MODULE,
>>>>> +             .pm = &gpio_extcon_pm_ops,
>>>>>       },
>>>>>  };
>>>>>
>>>>>
>>>>
>>>
>>> -barry
> 
> -barry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

