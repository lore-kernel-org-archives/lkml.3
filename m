Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaAIAye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:54:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63171 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbaAIAy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:54:28 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-73-52cdf3420918
Message-id: <52CDF345.6070609@samsung.com>
Date: Thu, 09 Jan 2014 09:54:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Rongjun Ying <Rongjun.Ying@csr.com>
Cc: RongJun Ying <rjying@gmail.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Barry Song <Barry.Song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <DL-SHA-WorkGroupLinux@internal.csr.com>
Subject: Re: [PATCH v3] extcon: gpio: Add power resume support
References: <1389070590-3139-1-git-send-email-rongjun.ying@csr.com>
 <52CB9A16.9010305@samsung.com>
 <86130EF012BDF348AA0D464A4F449478012AC858E6@SHAASIEXM01.ASIA.ROOT.PRI>
In-reply-to: <86130EF012BDF348AA0D464A4F449478012AC858E6@SHAASIEXM01.ASIA.ROOT.PRI>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkUNfp89kgg0839SwuT1rPZDGrq4XR
	YtPja6wWl3fNYbO43biCzeJW7wFmi30X/rA6sHvs2jmH1WPnrLvsHu/v3Gb12Lyk3qNvyypG
	j8+b5ALYorhsUlJzMstSi/TtErgybi25zVKwTKni4PHJjA2MO2W6GDk5JARMJF51zmaHsMUk
	Ltxbz9bFyMUhJLCUUeL0+WesMEXXv/UxQSSmM0rs2d7CAuG8YpRo6Z0DVMXBwSugJbH+oSqI
	ySKgKnFzTQJILxtQdP+LG2wgtqhAmMTK6VdYQGxeAUGJH5PvgdkiAuoSWxa0gM1nFjjMJLG5
	/QQzSEJYwE6i9eJ/dohdaxklLl3tZgJJcAqESqz6tpsRZBmzgJ7E/YtaIGFmAXmJzWveMoPU
	SwjcYpd4ducQI0iCRUBA4tvkQywg9RICshKbDjBDPCYpcXDFDZYJjGKzkNw0C2HqLCRTFzAy
	r2IUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIjL7T/55N3MF4/4D1IcZkoI0TmaVEk/OB0ZtX
	Em9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxrfP1d
	L93SsVLd19gg97k+6XjSvqinl8/z/LO/pe1cXnhE8ND70k6pztmzp8g/Np8b0NA+2Wnp1dNC
	FQGz30z+/umkrNy+7JDsObO4mI5MDPSyTSuKjOifcCHjbMl7s3niLuaLP035s7ChJNdY7Mxv
	RsGd356pSdZsX1/1pHLqvRv71PNf+rsosRRnJBpqMRcVJwIAyuXJHdQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV2nz2eDDD48UrW4PGk9k8WsrhZG
	i02Pr7FaXN41h83iduMKNotbvQeYLfZd+MPqwO6xa+ccVo+ds+6ye7y/c5vVY/OSeo++LasY
	PT5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHFryW2WgmVKFQeP
	T2ZsYNwp08XIySEhYCJx/VsfE4QtJnHh3nq2LkYuDiGB6YwSe7a3sEA4rxglWnrnsHYxcnDw
	CmhJrH+oCmKyCKhK3FyTANLLBhTd/+IGG4gtKhAmsXL6FRYQm1dAUOLH5HtgtoiAusSWBS1M
	ICOZBQ4zSWxuP8EMkhAWsJNovfifHWLXWkaJS1e7wS7iFAiVWPVtNyPIMmYBPYn7F7VAwswC
	8hKb17xlnsAoMAvJjlkIVbOQVC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzbz6R3
	MK5qsDjEKMDBqMTDu6L4bJAQa2JZcWXuIUYJDmYlEV7/T0Ah3pTEyqrUovz4otKc1OJDjMnA
	AJjILCWanA9MO3kl8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wGi3Od28JaFja66Ia+iWSfP/5Z4y6e303ium9V375mqNR4Ip3ntuOH7/9vCHkpfvx/n2fvWX
	MuPrq39MsLfcIpYQ4ukpYmpj3eVdtNrMo22SGpdKbsLSP3kiWw/ERjcsnv4077XCu/LjuipX
	xe95f121eV26idd0h+99Z47sfpAnY3ycf01XjRJLcUaioRZzUXEiAPQ5Q/IxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rongjun,

OK, I applied this patch on extcon-next branch.

Thannks,
Chanwoo Choi

On 01/07/2014 06:02 PM, Rongjun Ying wrote:
> 
> 
>> -----Original Message-----
>> From: Chanwoo Choi [mailto:cw00.choi@samsung.com]
>> Sent: Tuesday, January 07, 2014 2:09 PM
>> To: RongJun Ying
>> Cc: MyungJoo Ham; Barry Song; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; DL-SHA-WorkGroupLinux; Rongjun Ying
>> Subject: Re: [PATCH v3] extcon: gpio: Add power resume support
>>
>> Hi RongJun,
>>
>> On 01/07/2014 01:56 PM, RongJun Ying wrote:
>>> From: Rongjun Ying <rongjun.ying@csr.com>
>>>
>>> When system on the suspend state, Some SoC can't get gpio interrupt.
>>> After system resume, need send extcon uevent to userspace.
>>>
>>> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
>>> Reviewed-by: Barry Song <Baohua.Song@csr.com>
>>> ---
>>>  -v3:
>>>  'check_on_resume' instead of 'load_sleep_irq' as Chanwoo Choi's
>> proposal.
>>>
>>>  drivers/extcon/extcon-gpio.c       |   20 ++++++++++++++++++++
>>>  include/linux/extcon/extcon-gpio.h |    1 +
>>>  2 files changed, 21 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-gpio.c
>>> b/drivers/extcon/extcon-gpio.c index 7e0dff5..fde52c1 100644
>>> --- a/drivers/extcon/extcon-gpio.c
>>> +++ b/drivers/extcon/extcon-gpio.c
>>> @@ -40,6 +40,7 @@ struct gpio_extcon_data {
>>>  	int irq;
>>>  	struct delayed_work work;
>>>  	unsigned long debounce_jiffies;
>>> +	bool check_on_resume;
>>>  };
>>>
>>>  static void gpio_extcon_work(struct work_struct *work) @@ -103,6
>>> +104,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>>  	extcon_data->gpio_active_low = pdata->gpio_active_low;
>>>  	extcon_data->state_on = pdata->state_on;
>>>  	extcon_data->state_off = pdata->state_off;
>>> +	extcon_data->check_on_resume = pdata->check_on_resume;
>>>  	if (pdata->state_on && pdata->state_off)
>>>  		extcon_data->edev.print_state = extcon_gpio_print_state;
>>>  	if (pdata->debounce) {
>>> @@ -159,12 +161,30 @@ static int gpio_extcon_remove(struct
>> platform_device *pdev)
>>>  	return 0;
>>>  }
>>>
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int gpio_extcon_resume(struct device *dev) {
>>> +	struct gpio_extcon_data *extcon_data;
>>> +
>>> +	extcon_data = dev_get_drvdata(dev);
>>> +	if (extcon_data->check_on_resume)
>>> +		queue_delayed_work(system_power_efficient_wq,
>>> +			&extcon_data->work, extcon_data->debounce_jiffies);
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
>>> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
>>> +	SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
>>
>> If CONFIG_PM_SLEEP is undefined, gpio_extcon_pm_ops cannot find
>> gpio_extcon_resume function.
>> You should define dummy function for gpio_extcon_resume function.
>>
>>
> In the include/Linux/pm.h
> If CONFIG_PM_SLEEP is undefined, the SET_SYSTEM_SLEEP_PM_OPS macro is bypassed.
> 
> #ifdef CONFIG_PM_SLEEP
> #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
>         .suspend = suspend_fn, \
>         .resume = resume_fn, \
>         .freeze = suspend_fn, \
>         .thaw = resume_fn, \
>         .poweroff = suspend_fn, \
>         .restore = resume_fn,
> #else
> #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
> #endif
>>
>>
>>  To report this email as spam click
>> https://www.mailcontrol.com/sr/MZbqvYs5QwJvpeaetUwhCQ==
>> UfkIuR0P8QH1DW7C+lVo3569nqreWejYcysfmF8UmgH1OQ== .
> 
> 
> Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
> More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
> New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

