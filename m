Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLRHX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:23:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17614 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaLRHX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:23:56 -0500
X-AuditID: cbfee68e-f79b46d000002b74-2f-5492810905e8
Message-id: <54928108.5080603@samsung.com>
Date: Thu, 18 Dec 2014 16:23:52 +0900
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
References: <1527528755.303581418883865069.JavaMail.weblogic@epmlwas01d>
In-reply-to: <1527528755.303581418883865069.JavaMail.weblogic@epmlwas01d>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkWJezcVKIwYwnIhaP1yxmsph/5Byr
	xaT7E1gsXr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW6za9YfRgc9jzbw1jB47Z91l91i85yWTx+Yl9R59W1YxenzeJBfAFsVlk5Kak1mWWqRv
	l8CV0fh4HkvBU5OKiy8EGxgPa3QxcnJICJhI/Hs1kwnCFpO4cG89WxcjF4eQwFJGie+v1rF0
	MXKAFT1f6AMRX8QocaT5HxOE85pR4sGp1Swg3bwCWhIbVn1mBrFZBFQlft7qZQOx2YDi+1/c
	ALNFBcIkVk6/AlUvKPFj8j0wW0RARuLqxu0sIEOZBT6wSrz+AtEsLFAscWnTB1YQW0jAQ2LH
	7l1gDZwCnhItu86ALWMWUJeYNG8RlC0vsXnNW2aQQRICrRwSi77/YYG4SEDi2+RDUO/ISmw6
	wAzxsqTEwRU3WCYwis1CctMsJGNnIRm7gJF5FaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZg
	DJ/+96xvB+PNA9aHGAU4GJV4eCX0JoUIsSaWFVfmHmI0BbpiIrOUaHI+MFHklcQbGpsZWZia
	mBobmVuaKYnzJkj9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuHD1kRlXvldr+shkC2QI
	T/AMdUw/Ef0tL33Kt+lluYuuaadv8f+wyczu0tRNodv4Nf4HSvySlo7rWL7HrvDSge1PIvg9
	d02YtmX+uavSRjEWT65ONF89o2jy6pqk6Y+Sjd/8vbVIZl2y6e/sSRX5/akuyitjElYr3txw
	4NwXvokc6f8lc7d8dFNiKc5INNRiLipOBAA0/NFD3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAV3OxkkhBosmcls8XrOYyWL+kXOs
	FpPuT2CxeP3C0KJ3wVU2i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbrFq1x9GBz6PNfPWMHrsnHWX3WPxnpdMHpuX1Hv0bVnF6PF5k1wAW1QDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0LVKCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozGx/NYCp6aVFx8IdjAeFiji5GDQ0LAROL5Qp8u
	Rk4gU0ziwr31bF2MXBxCAosYJY40/2OCcF4zSjw4tZoFpIpXQEtiw6rPzCA2i4CqxM9bvWwg
	NhtQfP+LG2C2qECYxMrpV6DqBSV+TL4HZosIyEhc3bidBWQos8AHVonXXyCahQWKJS5t+sAK
	YgsJeEjs2L0LrIFTwFOiZdcZsGXMAuoSk+YtgrLlJTavecs8gVFgFpIds5CUzUJStoCReRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcIJ4Jr2DcVWDxSFGAQ5GJR5eCb1JIUKsiWXFlbmH
	GCU4mJVEeKNzgEK8KYmVValF+fFFpTmpxYcYTYFBMJFZSjQ5H5i88kriDY1NzIwsjcwNLYyM
	zZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGEUmbmVQtu9xOum/bNc/uQ0SPDZTtVe46kdd
	WtDSHiPOv/jFR91uMcmAD7vOz/9Z8j7JJu9+TSvL6WKPhvupC86zXXr00vBYqqxJtFOyaYvC
	IpbWY5ciPxz5wxuW/mL5j2szbus37NIKUpy2IOfzRP6ul8oSz8XL+OZd33Yvde2xLcHS2zpX
	sCqxFGckGmoxFxUnAgC3MwShJgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

Thanks for your review.

On 12/18/2014 03:24 PM, MyungJoo Ham wrote:
> Hi Chanwoo,
> 
> I love the idea and I now have a little mechanical issues in your code.
> 
>> ---
>>  drivers/devfreq/Kconfig         |   2 +
>>  drivers/devfreq/Makefile        |   5 +-
>>  drivers/devfreq/devfreq-event.c | 449 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/devfreq/event/Makefile  |   1 +
>>  include/linux/devfreq.h         | 160 ++++++++++++++
>>  5 files changed, 616 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/devfreq/devfreq-event.c
>>  create mode 100644 drivers/devfreq/event/Makefile
>>
>> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
>> index faf4e70..4d15b62 100644
>> --- a/drivers/devfreq/Kconfig
>> +++ b/drivers/devfreq/Kconfig
>> @@ -87,4 +87,6 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>>  	  It reads PPMU counters of memory controllers and adjusts the
>>  	  operating frequencies and voltages with OPP support.
>>  
>> +comment "DEVFREQ Event Drivers"
>> +
>>  endif # PM_DEVFREQ
>> diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
>> index 16138c9..a1ffabe 100644
>> --- a/drivers/devfreq/Makefile
>> +++ b/drivers/devfreq/Makefile
>> @@ -1,4 +1,4 @@
>> -obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
>> +obj-$(CONFIG_PM_DEVFREQ)		+= devfreq.o devfreq-event.o
>>  obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
>>  obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
>>  obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
>> @@ -7,3 +7,6 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
>>  # DEVFREQ Drivers
>>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
>>  obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
>> +
>> +# DEVFREQ Event Drivers
>> +obj-$(CONFIG_PM_DEVFREQ)		+= event/
>>
> 
> It looks getting mature fast.
> However, I would like to suggest you to
> 
> allow not to compile devfreq-event.c and not include its compiled object
>   if devfreq.c is required but devfreq-event.c is not required.
>   (e.g., add CONFIG_PM_DEVFREQ_EVENT and let it be enabled when needed)
>   just a little concern for lightweight devices.
>     (this change might require a bit more work on the header as well)
>   - Or do you think devfreq-event.c will become almost mandatory for
>    most devfreq drivers?

I agree your opinion.
I'll add CONFIG_PM_DEVFREQ_EVENT according to your comment.

> 
> 
> [snip]
> 
>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>> new file mode 100644
>> index 0000000..0e1948e
>> --- /dev/null
>> +++ b/drivers/devfreq/devfreq-event.c
>> @@ -0,0 +1,449 @@
>> +/*
>> + * devfreq-event: Generic DEVFREQ Event class driver
> 
> DEVFREQ is a generic DVFS mechanism (or subsystem).
> 
> Plus, I thought devfreq-event is considered to be a "framework"
> for devfreq event class drivers. Am I mistaken?

You're right. just "class driver" description is not proper.
I'll modify the description of devfreq-event.c as following:
or If you have other opinion, would you please let me know about it?

	devfreq-event: DEVFREQ-Event Framework to provide raw data of Non-CPU Devices.


> [snip]
> 
>> +struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
>> +                                               struct devfreq_event_desc *desc)
>> +{
>> +       struct devfreq_event_dev *edev;
>> +       static atomic_t event_no = ATOMIC_INIT(0);
>> +       int ret;
>> +
>> +       if (!dev || !desc)
>> +               return ERR_PTR(-EINVAL);
>> +
>> +       if (!desc->name || !desc->ops)
>> +               return ERR_PTR(-EINVAL);
>> +
>> +       if (!desc->ops->set_event || !desc->ops->get_event)
>> +               return ERR_PTR(-EINVAL);
>> +
>> +       edev = devm_kzalloc(dev, sizeof(*edev), GFP_KERNEL);
>> +       if (!edev)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       mutex_lock(&devfreq_event_list_lock);
> 
> You seem to lock that global lock too long. That lock is only required
> while you operate the list. The data to be protected by this mutex is
> devfreq_event_list. Until the new entry is added to the list, the new
> entry is free from protection. (may be delayed right before list_add)

OK. I'll move global lock right before calling list_add() on below.

> 
>> +       mutex_init(&edev->lock);
>> +       edev->desc = desc;
>> +       edev->dev.parent = dev;
>> +       edev->dev.class = devfreq_event_class;
>> +       edev->dev.release = devfreq_event_release_edev;
>> +
>> +       dev_set_name(&edev->dev, "event.%d", atomic_inc_return(&event_no) - 1);
>> +       ret = device_register(&edev->dev);
>> +       if (ret < 0) {
>> +               put_device(&edev->dev);
>> +               mutex_unlock(&devfreq_event_list_lock);
>> +               return ERR_PTR(ret);
>> +       }
>> +       dev_set_drvdata(&edev->dev, edev);
>> +
>> +       INIT_LIST_HEAD(&edev->node);
>> +       list_add(&edev->node, &devfreq_event_list);
>> +       mutex_unlock(&devfreq_event_list_lock);
>> +
>> +       return edev;
>> +}
> 
> 
> 
> [snip / reversed maybe.. sorry]
> 
>> +/**
>> + * devfreq_event_is_enabled() - Check whether devfreq-event dev is enabled or
>> + *                             not.
>> + * @edev       : the devfreq-event device
>> + *
>> + * Note that this function check whether devfreq-event dev is enabled or not.
>> + * If return true, the devfreq-event dev is enabeld. If return false, the
>> + * devfreq-event dev is disabled.
>> + */
>> +bool devfreq_event_is_enabled(struct devfreq_event_dev *edev)
>> +{
>> +       bool enabled = false;
>> +
>> +       if (!edev || !edev->desc)
>> +               return enabled;
>> +
>> +       mutex_lock(&edev->lock);
>> +
>> +       if (edev->enable_count > 0)
>> +               enabled = true;
>> +
>> +       if (edev->desc->ops && edev->desc->ops->is_enabled)
>> +               enabled |= edev->desc->ops->is_enabled(edev);
> 
> What does it mean when enabled_count > 0 and ops->is_enabled() is false? or..
> What does it mean when enabled_count = 0 and ops->is_enabled() is true?
> 
> If you do enable_count in the subsystem, why would we rely on
> ops->is_enabled()? Are you assuming that a device MAY turn itself off
> without any kernel control (ops->disable()) and it is still a correct
> behabior?

You're right. devfreq_event_is_enabled() has ambiguous operation according to your comment.

I'll only control the enable_count in the subsystem without ops->is_enabled()
and then remove the is_enabled function in the structre devfreq_event_ops.

Best Regards,
Chanwoo Choi
