Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaLSGqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:46:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61297 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLSGqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:46:11 -0500
X-AuditID: cbfee68d-f79296d000004278-2d-5493c9ae3eb6
Message-id: <5493C9AE.1020202@samsung.com>
Date: Fri, 19 Dec 2014 15:46:06 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv4 1/8] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
References: <1107836838.16761418955089663.JavaMail.weblogic@epmlwas08d>
In-reply-to: <1107836838.16761418955089663.JavaMail.weblogic@epmlwas08d>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkUHfdyckhBp/OGVs8XrOYyWL+kXOs
	FpPuT2CxeP3C0KJ3wVU2i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbrFq1x9GBz6PNfPWMHrsnHWX3WPxnpdMHpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+
	XQJXxulXfAUvFCp2P5vK3sB4R7KLkZNDQsBEYs6XDjYIW0ziwr31QDYXh5DAUkaJjadnsMIU
	LZu1khUisYhR4uS+dVDOa0aJCRO2sXQxcnDwCmhJ3NlvDdLAIqAqcXjfO2YQmw0ovP/FDbAN
	ogJhEiunX2EBsXkFBCV+TL4HZosIyEhc3bidBWQms8AHVonXX3rBGoQFiiUubfrACjJfSMBd
	4kB7HkiYU8BDou1NM1gJs4C6xKR5i5ghbHmJzWveMoPMkRDo5JC4f/QUM8RBAhLfJh8Cu1NC
	QFZi0wFmiMckJQ6uuMEygVFsFpKTZiEZOwvJ2AWMzKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLz
	czcxAiP49L9nvTsYbx+wPsQowMGoxMPbWTg5RIg1say4MvcQoynQFROZpUST84FpIq8k3tDY
	zMjC1MTU2Mjc0kxJnFdR6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsapMV5vjz+Ou92V
	unjNAZtGrtbVW6ttSoVtNa+uebPkquB6Pvf78XKrWNmZLd7/YPiqlhT7mS3Q2MnwkIFEoPfX
	158ueshOm1Odq3h2pTfbbWsZZdbtd5N5GIT+8a8SPDFf7U7YMQYf/3/W9dd2SgZZJH87xHWs
	a/fJ2EtKyx7ddBflCsyKWaPEUpyRaKjFXFScCAA2HaVS2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd11JyeHGNzr1LJ4vGYxk8X8I+dY
	LSbdn8Bi8fqFoUXvgqtsFmeb3rBbbHp8jdXi8q45bBafe48wWsw4v4/JYun1i0wWtxtXsFk8
	XvGW3WLVrj+MDnwea+atYfTYOesuu8fiPS+ZPDYvqffo27KK0ePzJrkAtqgGRpuM1MSU1CKF
	1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoGuVFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmnX/EVvFCo2P1sKnsD4x3JLkZODgkBE4lls1ay
	QthiEhfurWfrYuTiEBJYxChxct86VgjnNaPEhAnbWLoYOTh4BbQk7uy3BmlgEVCVOLzvHTOI
	zQYU3v/iBhuILSoQJrFy+hUWEJtXQFDix+R7YLaIgIzE1Y3bWUBmMgt8YJV4/aUXrEFYoFji
	0qYPrCDzhQTcJQ6054GEOQU8JNreNIOVMAuoS0yat4gZwpaX2LzmLfMERoFZSFbMQlI2C0nZ
	AkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB6eGZ1A7GlQ0WhxgFOBiVeHg7CieHCLEm
	lhVX5h5ilOBgVhLhdTwOFOJNSaysSi3Kjy8qzUktPsRoCgyBicxSosn5wNSVVxJvaGxiZmRp
	ZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA6DHv7TN96fmGSUt7Oabcn/vCj8nP
	Q/+q7KLkwEMnZhsVZGYeES0u/rU1M3G/9JlVgafz8rb/PLX19AKvu1+/zveSnf+/UPfOAtnf
	iQe6peI3iCqnHH1m3uj5On7ujogjDC9syz8XPX9YvOu8AFdlz4fU+gNTf9jY2326vE848e3j
	+PvZ28UrRJVYijMSDbWYi4oTAbOuhpElAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 12/19/2014 11:11 AM, MyungJoo Ham wrote:
>>   
>>  Dear Myungjoo,
>>
>> Thanks for your review.
>>
>> On 12/18/2014 03:24 PM, MyungJoo Ham wrote:
>>> Hi Chanwoo,
>>>
>>> I love the idea and I now have a little mechanical issues in your code.
>>>
>>>> ---
>>>>  drivers/devfreq/Kconfig         |   2 +
>>>>  drivers/devfreq/Makefile        |   5 +-
>>>>  drivers/devfreq/devfreq-event.c | 449 ++++++++++++++++++++++++++++++++++++++++
>>>>  drivers/devfreq/event/Makefile  |   1 +
>>>>  include/linux/devfreq.h         | 160 ++++++++++++++
>>>>  5 files changed, 616 insertions(+), 1 deletion(-)
>>>>  create mode 100644 drivers/devfreq/devfreq-event.c
>>>>  create mode 100644 drivers/devfreq/event/Makefile
>>>>
> 
> []
> 
>>
>>>
>>>
>>> [snip]
>>>
>>>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>>>> new file mode 100644
>>>> index 0000000..0e1948e
>>>> --- /dev/null
>>>> +++ b/drivers/devfreq/devfreq-event.c
>>>> @@ -0,0 +1,449 @@
>>>> +/*
>>>> + * devfreq-event: Generic DEVFREQ Event class driver
>>>
>>> DEVFREQ is a generic DVFS mechanism (or subsystem).
>>>
>>> Plus, I thought devfreq-event is considered to be a "framework"
>>> for devfreq event class drivers. Am I mistaken?
>>
>> You're right. just "class driver" description is not proper.
>> I'll modify the description of devfreq-event.c as following:
>> or If you have other opinion, would you please let me know about it?
>>
>> 	devfreq-event: DEVFREQ-Event Framework to provide raw data of Non-CPU Devices.
> 
> devfreq-event: a framework to provide raw data and events of devfreq devices
> 
> should be enough.

OK, I'll modify it.

> 
> 
> []
>>> [snip / reversed maybe.. sorry]
>>>
>>>> +/**
>>>> + * devfreq_event_is_enabled() - Check whether devfreq-event dev is enabled or
>>>> + *                             not.
>>>> + * @edev       : the devfreq-event device
>>>> + *
>>>> + * Note that this function check whether devfreq-event dev is enabled or not.
>>>> + * If return true, the devfreq-event dev is enabeld. If return false, the
>>>> + * devfreq-event dev is disabled.
>>>> + */
>>>> +bool devfreq_event_is_enabled(struct devfreq_event_dev *edev)
>>>> +{
>>>> +       bool enabled = false;
>>>> +
>>>> +       if (!edev || !edev->desc)
>>>> +               return enabled;
>>>> +
>>>> +       mutex_lock(&edev->lock);
>>>> +
>>>> +       if (edev->enable_count > 0)
>>>> +               enabled = true;
>>>> +
>>>> +       if (edev->desc->ops && edev->desc->ops->is_enabled)
>>>> +               enabled |= edev->desc->ops->is_enabled(edev);
>>>
>>> What does it mean when enabled_count > 0 and ops->is_enabled() is false? or..
>>> What does it mean when enabled_count = 0 and ops->is_enabled() is true?
>>>
>>> If you do enable_count in the subsystem, why would we rely on
>>> ops->is_enabled()? Are you assuming that a device MAY turn itself off
>>> without any kernel control (ops->disable()) and it is still a correct
>>> behabior?
>>
>> You're right. devfreq_event_is_enabled() has ambiguous operation according to your comment.
>>
>> I'll only control the enable_count in the subsystem without ops->is_enabled()
>> and then remove the is_enabled function in the structre devfreq_event_ops.
>>
>> Best Regards,
>> Chanwoo Choi
>>
> 
> [Off-Topic]
> 
> The name of devfreq-event may look quite intersecting with irq-driven governors,
> which are being proposed these days.
> 
> Although they may look intersecting, we can have them independently;
> this as a sub-class and that as a governor. And we can consider to
> provide a common infrastructure for irq-driven mechanisms in devfreq or
> devfreq-event when we irq-driven DVFS become more general, which I
> expect in 2 ~ 3 years.
> 
> So for now, both can go independently.

I understand your opinion.
I want to handle the devfreq-event framework independently from irq-driven governor.

After completing the devfreq-event and the support for exynos-busfreq dt,
If you agree, I'll consider how to implement irq-driven governor as the devfreq governor.

Best Regards,
Chanwoo Choi
