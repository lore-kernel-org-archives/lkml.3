Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaLPCyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:54:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15891 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaLPCug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:50:36 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-a0-548f9df93a27
Content-transfer-encoding: 8BIT
Message-id: <548F9DF8.80508@samsung.com>
Date: Tue, 16 Dec 2014 11:50:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [RFC PATCHv2 1/7] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
 <1418134386-14681-2-git-send-email-cw00.choi@samsung.com>
 <1418204220.16644.14.camel@AMDC1943> <5488FDCE.2060009@samsung.com>
 <548A643D.10508@samsung.com> <1418639428.7591.5.camel@AMDC1943>
In-reply-to: <1418639428.7591.5.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkQPfn3P4Qg0N/uC0er1nMZLFxxnpW
	i/lHzrFavH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyuN24gs3i8Yq37Bar
	dv1hdOD12DnrLrvH4j0vmTw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsEroyT39eyFqyI
	qNg2rYelgbHfs4uRk0NCwETi7PHVjBC2mMSFe+vZuhi5OIQEljJKtPe1sMIUfTj+jx0iMZ1R
	4m3vETaQBK+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreIGaL+NaPE4w2vGCHqNSQuTv0G
	ZrMIqErcW3aWCcRmE9CS2P/iBthMUYEwiZXTr7CA2CIChhIHd29nghh6nUnizg2wq4UFyiUe
	HD0KNkdIoJNJ4tu8RBCbU0Bf4seF82CLJQT+skvce76ADWKZgMS3yYfADpUQkJXYdIAZ4jFJ
	iYMrbrBMYBSbheSdWQjvzELyzgJG5lWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgdF6+t+z
	CTsY7x2wPsQowMGoxMMbUNgfIsSaWFZcmXuI0RToiInMUqLJ+cCUkFcSb2hsZmRhamJqbGRu
	aaYkzvta6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbCBPWjNg8U9VwK2A8EbWmtX1E0
	Vy37YFyBnv+EN3kvdFJd7v2ZxpkSnFwdcKho3au7XxOTHS32/LFVm5X0tY27cZeEAF/Jlpe5
	Zdy7K002ebEeZ5g0u/VRr5zmj+3uHjcsGRK2r9hTcPPIBe0VUxrO7zjvfnn78fm5S25cX2Eb
	yvilJ3v2vrtKLMUZiYZazEXFiQA8VSWF0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoO7Puf0hBp+/Mlo8XrOYyWLjjPWs
	FvOPnGO1eP3C0KJ3wVU2i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dkcbtxBZvF4xVv2S1W
	7frD6MDrsXPWXXaPxXteMnlsXlLv0bdlFaPH501yAaxRDYw2GamJKalFCql5yfkpmXnptkre
	wfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA3KimUJeaUAoUCEouLlfTtME0IDXHTtYBp
	jND1DQmC6zEyQAMJaxgzTn5fy1qwIqJi27QelgbGfs8uRk4OCQETiQ/H/7FD2GISF+6tZ+ti
	5OIQEpjOKPG29wgbSIJXQFDix+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR/5pR4vGGV4wQ
	9RoSF6d+A7NZBFQl7i07ywRiswloSex/cQNspqhAmMTK6VdYQGwRAUOJg7u3M0EMvc4kcecG
	2HHCAuUSD44eBZsjJNDJJPFtXiKIzSmgL/HjwnnmCYwCs5CcNwvhvFlIzlvAyLyKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzgVPJPawbiyweIQowAHoxIPb0Bhf4gQa2JZcWXuIUYJDmYl
	EV73qUAh3pTEyqrUovz4otKc1OJDjKZAz01klhJNzgemqbySeENjEzMjSyNzQwsjY3MlcV4l
	+7YQIYH0xJLU7NTUgtQimD4mDk6pBsaOt9PfzTrzaE2RrMHrs4VJz+MvV4bd57V/EnBtZ8cD
	VdZDqwS6/xd/nMytqCLb037LWDN1xYOiyecPbJosfdkqZEaZpnz2t6wjfyYeznO5o6204ZdT
	TvDxRQub2tbN/X+q48bsk17tKy1Ws09j1b+zPF5fSn7O3l87nswMumZSL9wl/P25/md/JZbi
	jERDLeai4kQAsvVaBRsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 12/15/2014 07:30 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-12-12 at 12:42 +0900, Chanwoo Choi wrote:
>> Hi Krzysztof,
>>
>> I replied again this mail because I'll use the mutex for set_event()/get_event()
>> according to your comment. But, of_parse_phandle() seems that this function
>> don't need the of_node_put() function.
>>
>>
>> On 12/11/2014 11:13 AM, Chanwoo Choi wrote:
>>> Hi Krzysztof,
>>>
>>> First of all, thanks for your review.
>>>
>>> On 12/10/2014 06:37 PM, Krzysztof Kozlowski wrote:
>>>> On wto, 2014-12-09 at 23:13 +0900, Chanwoo Choi wrote:
>>>>> This patch add new devfreq_event class for devfreq_event device which provide
>>>>> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
>>>>> devfreq_event data would be used for the governor of devfreq subsystem.
>>>>> - devfreq_event device : Provide raw data for governor of existing devfreq device
>>>>> - devfreq device       : Monitor device state and change frequency/voltage of device
>>>>>                          using the raw data from devfreq_event device
>>>>>
>>>>> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
>>>>> for Non-CPU Devices. The devfreq device would dertermine current device state
>>>>> using various governor (e.g., ondemand, performance, powersave). After completed
>>>>> determination of system state, devfreq device would change the frequency/voltage
>>>>> of devfreq device according to the result of governor.
>>>>>
>>>>> But, devfreq governor must need basic data which indicates current device state.
>>>>> Existing devfreq subsystem only consider devfreq device which check current system
>>>>> state and determine proper system state using basic data. There is no subsystem
>>>>> for device providing basic data to devfreq device.
>>>>>
>>>>> The devfreq subsystem must need devfreq_event device(data-provider device) for
>>>>> existing devfreq device. So, this patch add new devfreq_event class for
>>>>> devfreq_event device which read various basic data(e.g, memory bus utilization,
>>>>> GPU utilization) and provide measured data to existing devfreq device through
>>>>> standard APIs of devfreq_event class.
>>>>>
>>>>> The following description explains the feature of two kind of devfreq class:
>>>>> - devfreq class (existing)
>>>>>  : devfreq consumer device use raw data from devfreq_event device for
>>>>>    determining proper current system state and change voltage/frequency
>>>>>    dynamically using various governors.
>>>>>
>>>>> - devfreq_event class (new)
>>>>>  : Provide measured raw data to devfreq device for governor
>>>>>
>>>>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>> ---
>>>>>  drivers/devfreq/Kconfig         |   2 +
>>>>>  drivers/devfreq/Makefile        |   5 +-
>>>>>  drivers/devfreq/devfreq-event.c | 302 ++++++++++++++++++++++++++++++++++++++++
>>>>>  drivers/devfreq/event/Makefile  |   1 +
>>>>>  include/linux/devfreq.h         | 141 +++++++++++++++++++
>>>>>  5 files changed, 450 insertions(+), 1 deletion(-)
>>>>>  create mode 100644 drivers/devfreq/devfreq-event.c
>>>>>  create mode 100644 drivers/devfreq/event/Makefile
>>>>>
>>>>> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
>>>>> index faf4e70..4d15b62 100644
>>>>> --- a/drivers/devfreq/Kconfig
>>>>> +++ b/drivers/devfreq/Kconfig
>>>>> @@ -87,4 +87,6 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>>>>>  	  It reads PPMU counters of memory controllers and adjusts the
>>>>>  	  operating frequencies and voltages with OPP support.
>>>>>  
>>>>> +comment "DEVFREQ Event Drivers"
>>>>> +
>>>>>  endif # PM_DEVFREQ
>>>>> diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
>>>>> index 16138c9..a1ffabe 100644
>>>>> --- a/drivers/devfreq/Makefile
>>>>> +++ b/drivers/devfreq/Makefile
>>>>> @@ -1,4 +1,4 @@
>>>>> -obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
>>>>> +obj-$(CONFIG_PM_DEVFREQ)		+= devfreq.o devfreq-event.o
>>>>>  obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
>>>>>  obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
>>>>>  obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
>>>>> @@ -7,3 +7,6 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
>>>>>  # DEVFREQ Drivers
>>>>>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
>>>>>  obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
>>>>> +
>>>>> +# DEVFREQ Event Drivers
>>>>> +obj-$(CONFIG_PM_DEVFREQ)		+= event/
>>>>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>>>>> new file mode 100644
>>>>> index 0000000..b47329f
>>>>> --- /dev/null
>>>>> +++ b/drivers/devfreq/devfreq-event.c
>>>>> @@ -0,0 +1,302 @@
>>>>> +/*
>>>>> + * devfreq-event: Generic DEVFREQ Event class driver
>>>>> + *
>>>>> + * Copyright (C) 2014 Samsung Electronics
>>>>> + * Chanwoo Choi <cw00.choi@samsung.com>
>>>>> + *
>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>> + * published by the Free Software Foundation.
>>>>> + *
>>>>> + * This driver is based on drivers/devfreq/devfreq.c
>>>>> + */
>>>>> +
>>>>> +#include <linux/kernel.h>
>>>>> +#include <linux/sched.h>
>>>>> +#include <linux/errno.h>
>>>>> +#include <linux/err.h>
>>>>> +#include <linux/init.h>
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/slab.h>
>>>>> +#include <linux/stat.h>
>>>>> +#include <linux/pm_opp.h>
>>>>> +#include <linux/devfreq.h>
>>>>> +#include <linux/workqueue.h>
>>>>> +#include <linux/platform_device.h>
>>>>> +#include <linux/list.h>
>>>>> +#include <linux/printk.h>
>>>>> +#include <linux/hrtimer.h>
>>>>> +#include <linux/of.h>
>>>>> +#include "governor.h"
>>>>> +
>>>>> +static struct class *devfreq_event_class;
>>>>> +
>>>>> +/* The list of all devfreq event list */
>>>>> +static LIST_HEAD(devfreq_event_list);
>>>>> +static DEFINE_MUTEX(devfreq_event_list_lock);
>>>>> +
>>>>> +#define to_devfreq_event(DEV) container_of(DEV, struct devfreq_event_dev, dev)
>>>>> +
>>>>> +struct devfreq_event_dev *devfreq_add_event_device(struct device *dev,
>>>>> +					struct devfreq_event_desc *desc)
>>>>> +{
>>>>> +	struct devfreq_event_dev *event_dev;
>>>>> +	static atomic_t event_no = ATOMIC_INIT(0);
>>>>> +	int ret;
>>>>> +
>>>>> +	if (!dev || !desc)
>>>>> +		return ERR_PTR(-EINVAL);
>>>>> +
>>>>> +	if (!desc->name || !desc->ops)
>>>>> +		return ERR_PTR(-EINVAL);
>>>>> +
>>>>> +	event_dev = kzalloc(sizeof(struct devfreq_event_dev), GFP_KERNEL);
>>>>> +	if (!event_dev)
>>>>> +		return ERR_PTR(-ENOMEM);
>>>>
>>>> Is this memory freed anywhere when driver is removed? I couldn't find
>>>> it. I couldn't also find function like devfreq_remove_event_device()
>>>> which would be reverting all the work done when adding.
>>>
>>> You're right. I'll use devm_kzalloc instead of kzalloc.
>>>
>>>>
>>>>> +
>>>>> +	mutex_lock(&devfreq_event_list_lock);
>>>>> +
>>>>> +	mutex_init(&event_dev->lock);
>>>>> +	event_dev->desc = desc;
>>>>> +	event_dev->dev.parent = dev;
>>>>> +	event_dev->dev.class = devfreq_event_class;
>>>>> +
>>>>> +	dev_set_name(&event_dev->dev, "event.%d",
>>>>> +		     atomic_inc_return(&event_no) - 1);
>>>>> +	ret = device_register(&event_dev->dev);
>>>>> +	if (ret != 0) {
>>>>> +		put_device(&event_dev->dev);
>>>>> +		goto err;
>>>>> +	}
>>>>> +	dev_set_drvdata(&event_dev->dev, event_dev);
>>>>> +
>>>>> +	/* Add devfreq event device to devfreq_event_list */
>>>>> +	INIT_LIST_HEAD(&event_dev->node);
>>>>> +	list_add(&event_dev->node, &devfreq_event_list);
>>>>> +
>>>>> +	mutex_unlock(&devfreq_event_list_lock);
>>>>> +
>>>>> +	return event_dev;
>>>>> +err:
>>>>
>>>> Missing 'mutex_unlock(&devfreq_event_list_lock)' here.
>>>
>>> OK. I'll fix it.
>>>
>>>>
>>>>
>>>>> +	kfree(event_dev);
>>>>> +	return ERR_PTR(ret);
>>>>> +}
>>>>> +EXPORT_SYMBOL(devfreq_add_event_device);
>>>>> +
>>>>> +struct devfreq_event_dev *devfreq_get_event_dev(const char *event_dev_name)
>>>>> +{
>>>>> +	struct devfreq_event_dev *event_dev;
>>>>> +
>>>>> +	mutex_lock(&devfreq_event_list_lock);
>>>>> +	list_for_each_entry(event_dev, &devfreq_event_list, node) {
>>>>> +		if (!strcmp(event_dev->desc->name, event_dev_name))
>>>>> +			goto out;
>>>>> +	}
>>>>> +	event_dev = NULL;
>>>>> +out:
>>>>> +	mutex_unlock(&devfreq_event_list_lock);
>>>>> +
>>>>> +	return event_dev;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(devfreq_get_event_dev);
>>>>> +
>>>>> +struct devfreq_event_dev *devfreq_get_event_dev_by_phandle(struct device *dev,
>>>>> +						      int index)
>>>>> +{
>>>>> +	struct device_node *node;
>>>>> +	struct devfreq_event_dev *event_dev;
>>>>> +
>>>>> +	if (!dev->of_node) {
>>>>> +		dev_err(dev, "device does not have a device node entry\n");
>>>>> +		return ERR_PTR(-EINVAL);
>>>>> +	}
>>>>> +
>>>>> +	node = of_parse_phandle(dev->of_node, "devfreq-events", index);
>>>>> +	if (!node) {
>>>>> +		dev_err(dev, "failed to get phandle in %s node\n",
>>>>> +			dev->of_node->full_name);
>>>>> +		return ERR_PTR(-ENODEV);
>>>>> +	}
>>>>> +
>>>>> +	event_dev = devfreq_get_event_dev(node->name);
>>>>> +	if (!event_dev) {
>>>>> +		dev_err(dev, "unable to get devfreq-event device : %s\n",
>>>>> +			node->name);
>>>>
>>>> of_node_put() for node obtained with of_parse_phandle().
>>>
>>> OK. I'll add it.
>>
>> of_parse_phandle() seems that it don't need of_node_put().
> 
> The of_parse_phandle() increases the refcount for node it returns.
>>From documentation:
> 
> /**
>  * Returns the device_node pointer with refcount incremented.  Use
>  * of_node_put() on it when done.
>  */
> 
> The function returns error condition but node was found and its refcnt
> was incremented. Then why do you think that of_node_put() is not
> necessary here?

OK, I'll call of_node_put() as following:

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index cd9c485..a1edafc 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -282,9 +282,12 @@ out:
        if (!edev) {
                dev_err(dev, "unable to get devfreq-event device : %s\n",
                        node->name);
+               of_node_put(node);
                return ERR_PTR(-ENODEV);
        }
 
+       of_node_put(node);
+
        return edev;
 }

> 
>>
>>>
>>>>
>>>>> +		return ERR_PTR(-ENODEV);
>>>>> +	}
>>>>> +
>>>>> +	return event_dev;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(devfreq_get_event_dev_by_phandle);
>>>>> +
>>>>> +int devfreq_put_event_dev(struct devfreq_event_dev *event_dev)
>>>>> +{
>>>>
>>>> of_node_put() here to decrement refcnt from of_parse_phandle()?
>>>
>>> It is my mistake. I think that devfreq_put_event_dev is not necesssary.
>>> I'll remove it.
> 
> Then how to decrease the refcnt for node obtained in
> devfreq_get_event_dev_by_phandle()?

I'll call of_node_put in devfreq_event_get_edev_by_phandle() according to your comment.

Thanks for your review.

Best Regards,
Chanwoo Choi

