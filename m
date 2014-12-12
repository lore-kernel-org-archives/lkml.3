Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbaLLIL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:11:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:17063 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577AbaLLIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:11:26 -0500
X-AuditID: cbfee691-f79b86d000004a5a-0a-548aa32a0d3c
Message-id: <548AA329.80002@samsung.com>
Date: Fri, 12 Dec 2014 17:11:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: cw00.choi@samsung.com
Cc: Chanwoo Choi <cwchoi00@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, rafael.j.wysocki@intel.com,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [RFC PATCHv2 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
 <1418206046.16644.26.camel@AMDC1943>
 <CAGTfZH3DoSCTTgW-6o3na_mO2-scrV1JftpdTM5u3w=EunLfaA@mail.gmail.com>
In-reply-to: <CAGTfZH3DoSCTTgW-6o3na_mO2-scrV1JftpdTM5u3w=EunLfaA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkUFdrcVeIwbYtIhaP1yxmstg4Yz2r
	xfUvz1ktnh3Vtph/5ByrxesXhha9C66yWZxtesNusenxNVaLy7vmsFl87j3CaDHj/D4mi9uN
	K9gsHq94y26xatcfRgd+j52z7rJ7LN7zkslj85J6j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL
	4Mo4Ou88W8F1zYqvM7YwNzA2KHUxcnJICJhIvDjQzwhhi0lcuLeerYuRi0NIYCmjxOkvD1m7
	GDnAilbfLYKIL2KU2P/mAitIg5DAa0aJ/59EQWxeAQ2Jv88WMYPYLAKqEtPXzGcDsdkEtCT2
	v7gBZosKhEmsnH6FBaJeUOLH5HssIPNFBCQlWvaZgcxnFuhjlTg8uZsRJC4skCHR+c4DYu9m
	RokrV2YxgfRyCgRLfFi3BOwGZgF1iUnzIPYyC8hLbF7zlhmkQUKgk0Piw7strBAHCUh8m3yI
	BeIZWYlNB5ghHpaUOLjiBssERrFZSE6ahWTsLCRjFzAyr2IUTS1ILihOSi8y1StOzC0uzUvX
	S87P3cQIjN/T/55N3MF4/4D1IUYBDkYlHt4XqV0hQqyJZcWVuYcYTYGumMgsJZqcD0wSeSXx
	hsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM5L7tTL8xZJ
	4/rmuzGU7Qcf19Pg2ctcOzKZme9+Zn//fM23iTfmuZyY9EDk9vRC1s+bnp9nvHj1yKZZj+/7
	OKeG7ZjQkhJ0be0+pyS1/Pu7yl/vidtXfNbf5iL73VvaaRo79Gskt745ce+QB2OeXd9dCdWD
	mW4S6nvPhmz5tvGKWtjp5DNaateVWIozEg21mIuKEwHdpeS02gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV2txV0hBr3vuSwer1nMZLFxxnpW
	i+tfnrNaPDuqbTH/yDlWi9cvDC16F1xlszjb9IbdYtPja6wWl3fNYbP43HuE0WLG+X1MFrcb
	V7BZPF7xlt1i1a4/jA78Hjtn3WX3WLznJZPH5iX1Hn1bVjF6fN4kF8Aa1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+i882wF1zUrvs7YwtzA2KDUxcjBISFgIrH6blEX
	IyeQKSZx4d56ti5GLg4hgUWMEvvfXGAFSQgJvGaU+P9JFMTmFdCQ+PtsETOIzSKgKjF9zXw2
	EJtNQEti/4sbYLaoQJjEyulXWCDqBSV+TL7HArJLREBSomWfGch8ZoE+VonDk7sZQeLCAhkS
	ne88IPZuZpS4cmUWE0gvp0CwxId1S8BuYBZQl5g0D2Ivs4C8xOY1b5knMArMQrJiFpKyWUjK
	FjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQITg7PpHYwrmywOMQowMGoxMP7IrUrRIg1
	say4MvcQowQHs5II798ooBBvSmJlVWpRfnxRaU5q8SFGU2AITGSWEk3OByauvJJ4Q2MTMyNL
	I3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkGxumH9wSz8TMt5T5ULmCzJvOny4PY
	z1r19yVW8cx28GtiFO6+8cbFme8ZX5XgzVjXe+5/+ed0MFnPDW0L8b4nImTAvOpckPaxJ0d3
	6KQun55Y+G/fVUmu/xM/Fq6tsPuZMelka/Ta02/8Oha1SRycw+B7j6NcSIBpmvmGLawVK+TO
	h4a+ulxUrsRSnJFoqMVcVJwIACT2ha8kAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 12/10/2014 10:21 PM, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> On Wed, Dec 10, 2014 at 7:07 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
>> On wto, 2014-12-09 at 23:12 +0900, Chanwoo Choi wrote:
>>> This patchset add new devfreq_event class to provide raw data to determine
>>> current utilization of device  which is used for devfreq governor.
>>>
>>> [Description of devfreq-event class]
>>> This patchset add new devfreq_event class for devfreq_event device which provide
>>> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
>>> devfreq_event data would be used for the governor of devfreq subsystem.
>>> - devfreq_event device : Provide raw data for governor of existing devfreq device
>>> - devfreq device       : Monitor device state and change frequency/voltage of device
>>>                          using the raw data from devfreq_event device
>>>
>>> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
>>> for Non-CPU Devices. The devfreq device would dertermine current device state
>>> using various governor (e.g., ondemand, performance, powersave). After completed
>>> determination of system state, devfreq device would change the frequency/voltage
>>> of devfreq device according to the result of governor.
>>>
>>> But, devfreq governor must need basic data which indicates current device state.
>>> Existing devfreq subsystem only consider devfreq device which check current system
>>> state and determine proper system state using basic data. There is no subsystem
>>> for device providing basic data to devfreq device.
>>>
>>> The devfreq subsystem must need devfreq_event device(data-provider device) for
>>> existing devfreq device. So, this patch add new devfreq_event class for
>>> devfreq_event device which read various basic data(e.g, memory bus utilization,
>>> GPU utilization) and provide measured data to existing devfreq device through
>>> standard APIs of devfreq_event class.
>>>
>>> The following description explains the feature of two kind of devfreq class:
>>> - devfreq class (existing)
>>>  : devfreq consumer device use raw data from devfreq_event device for
>>>    determining proper current system state and change voltage/frequency
>>>    dynamically using various governors.
>>> - devfreq_event class (new)
>>>  : Provide measured raw data to devfreq device for governor
>>>
>>> Also, the devfreq-event device would support various type event as following:
>>>  : DEVFREQ_EVENT_TYPE_RAW_DATA
>>>  : DEVFREQ_EVENT_TYPE_UTILIZATION
>>>  : DEVFREQ_EVENT_TYPE_BANDWIDTH
>>>  : DEVFREQ_EVENT_TYPE_LATENCY
>>>
>>> [For example]
>>> If board dts includes PPMU_DMC0/DMC1/CPU event node,
>>> would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
>>> can get the instance of devfreq-event device by using provided API and then
>>> get raw data which reflect the current state of device.
>>>
>>
>> Hi,
>>
>> Overall I like the idea. I understand that now devfreq devices (like
>> exynos devfreq) should bind themselves to buses, not to PPMU. It makes
>> sense to me because bus clock and bus voltage are properties of bus, not
>> monitoring unit.
>>
>> I see that this is still a RFC so it would be hard to base current
>> devfreq work on top of it.
> 
> The goal of this patch set is not for devfreq device. This patch set
> just is used for
> devfreq-event device according to patch description.
> 
> The devfreq must need devfreq-event device (e.g., exynos-ppmu.c)
> but current devfreq subsystem have not been supported any reason for
> exyons-ppmu.c as devfreq-event device.
> 
> I discussed this same issue on following patch[1] which was posted to support
> exynos4 busfreq by me.
> [1] https://lkml.org/lkml/2014/3/14/132
> - [PATCHv2 8/8] devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
> After discussion, I thought that devfreq-event class must be needed
> before supporting
> the dt of devfreq device.
> 
> So, I think that devfreq have to support the devfreq-event subsystem
> for exynos-ppmu. And then I'll work to support the device-tree of devfreq device
> as next job.
> 
>>
>> One more general comment: you're adding a some API which is not used by
>> current devfreq_event user (exynos). For example the exclusive flag or
>> event types. I think it will be simpler to stick to the basic approach
>> (reduced API). If some other user emerges then new API will be added.
> 
> I think that devfreq-event must support both event_flag(e.g., exclusive flag)
> and event_type(e.g., raw_data, utilization, bandwidth, latency) because
> devfreq-event device (e.g., exynos-ppmu) would provide various event data.
> For example, exynos-ppmu driver could support the utilization/bandwidth/latency
> of each IP of Exynos SoC. I checked PPMU IP on Exynos TRM.
> 
> Also, If specific devfreq-event device should be used on only one device driver,
> devfrewq-event class have to support 'exclusive' flag. If
> devfreq-event class don't
> support the exclusive flag, devfreq-event could not guarantee the
> integrity of event
> from devfreq-event device.

I'll drop 'exclusive' flag according to your comment.

Thanks for your review.

Best Regards,
Chanwoo Choi


