Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbaLKCNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:13:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59203 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbaLKCNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:13:37 -0500
X-AuditID: cbfee68e-f79b46d000002b74-b6-5488fdce7607
Message-id: <5488FDCE.2060009@samsung.com>
Date: Thu, 11 Dec 2014 11:13:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
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
 <1418204220.16644.14.camel@AMDC1943>
In-reply-to: <1418204220.16644.14.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkRPfc344Qg9v7DC0er1nMZLFxxnpW
	i/lHzrFavH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyuN24gs3i8Yq37Bar
	dv1hdOD12DnrLrvH4j0vmTw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsEroxle7UKdidX
	XFx1k7mB8UFgFyMnh4SAicTla9sYIWwxiQv31rN1MXJxCAksZZTYeXcaUxcjB1jR1b3BEPFF
	jBJf+y5BFb1mlFi5sYcJpJtXQEtibnMHG4jNIqAqMeXUTDCbDSi+/8UNMFtUIExi5fQrLBD1
	ghI/Jt8Ds0UEDCUO7t4ONodZ4DqTxJ0bniC2sEC5xIOjR8GuExJYwSix6g0XiM0JVL/y2gdG
	iHp1iUnzFjFD2PISm9e8ZQY5TkLgK7vEv3mLWSEOEpD4NvkQC8Q3shKbDjBDfCwpcXDFDZYJ
	jGKzkJw0C8nYWUjGLmBkXsUomlqQXFCclF5kpFecmFtcmpeul5yfu4kRGK2n/z3r28F484D1
	IUYBDkYlHt6Ay+0hQqyJZcWVuYcYTYGumMgsJZqcD0wJeSXxhsZmRhamJqbGRuaWZkrivAlS
	P4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MNZ5vNdrFPoR8WyPO9Ntjd9r2zYb9jB+6pvZ
	ukB+gsWfadMbv3Oour9Qdlm8IOhVg+oSt7lPf+lGrdxa8FA54qFo7c/tybUnGaNfZrGyzf/s
	XB1TVDe9QE3g1u7Nr23u+K4UWaW2fG+wzosJx104Fn7pNZE/r9Oc1fDtaOFHNXkXrhJx+0eS
	XUosxRmJhlrMRcWJAOLrStzRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgO65vx0hBvdb1Swer1nMZLFxxnpW
	i/lHzrFavH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyuN24gs3i8Yq37Bar
	dv1hdOD12DnrLrvH4j0vmTw2L6n36NuyitHj8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv
	4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAblRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0
	Ruj6hgTB9RgZoIGENYwZy/ZqFexOrri46iZzA+ODwC5GDg4JAROJq3uDuxg5gUwxiQv31rN1
	MXJxCAksYpT42ncJynnNKLFyYw8TSBWvgJbE3OYONhCbRUBVYsqpmWA2G1B8/4sbYLaoQJjE
	yulXWCDqBSV+TL4HZosIGEoc3L0dbA6zwHUmiTs3PEFsYYFyiQdHjzKC2EICKxglVr3hArE5
	gepXXvvACFGvLjFp3iJmCFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEp4Jn0jsYVzVYHGIU4GBU4uENuNweIsSaWFZcmXuIUYKDWUmEN+lGR4gQ
	b0piZVVqUX58UWlOavEhRlNgCExklhJNzgemqbySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0
	xJLU7NTUgtQimD4mDk6pBsb4+p7aSU9YzuQUtR1+P1E22por005fUylSaN2CvfImFd9alRcs
	0iyoiPyo4+k9paFp7Z8bl6el/Du5tOjOxd+58psWuKwM+rUvj7VtQf2tjC0rHritW1gy8cPj
	Z67//rM+mB3+PejdkYTzz9Qu3j+1ZRpv7OPdQfO9Ehg1T8RtWvD5f+sqb6kJSizFGYmGWsxF
	xYkAibeLrRsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

First of all, thanks for your review.

On 12/10/2014 06:37 PM, Krzysztof Kozlowski wrote:
> On wto, 2014-12-09 at 23:13 +0900, Chanwoo Choi wrote:
>> This patch add new devfreq_event class for devfreq_event device which provide
>> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
>> devfreq_event data would be used for the governor of devfreq subsystem.
>> - devfreq_event device : Provide raw data for governor of existing devfreq device
>> - devfreq device       : Monitor device state and change frequency/voltage of device
>>                          using the raw data from devfreq_event device
>>
>> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
>> for Non-CPU Devices. The devfreq device would dertermine current device state
>> using various governor (e.g., ondemand, performance, powersave). After completed
>> determination of system state, devfreq device would change the frequency/voltage
>> of devfreq device according to the result of governor.
>>
>> But, devfreq governor must need basic data which indicates current device state.
>> Existing devfreq subsystem only consider devfreq device which check current system
>> state and determine proper system state using basic data. There is no subsystem
>> for device providing basic data to devfreq device.
>>
>> The devfreq subsystem must need devfreq_event device(data-provider device) for
>> existing devfreq device. So, this patch add new devfreq_event class for
>> devfreq_event device which read various basic data(e.g, memory bus utilization,
>> GPU utilization) and provide measured data to existing devfreq device through
>> standard APIs of devfreq_event class.
>>
>> The following description explains the feature of two kind of devfreq class:
>> - devfreq class (existing)
>>  : devfreq consumer device use raw data from devfreq_event device for
>>    determining proper current system state and change voltage/frequency
>>    dynamically using various governors.
>>
>> - devfreq_event class (new)
>>  : Provide measured raw data to devfreq device for governor
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/Kconfig         |   2 +
>>  drivers/devfreq/Makefile        |   5 +-
>>  drivers/devfreq/devfreq-event.c | 302 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/devfreq/event/Makefile  |   1 +
>>  include/linux/devfreq.h         | 141 +++++++++++++++++++
>>  5 files changed, 450 insertions(+), 1 deletion(-)
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
>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>> new file mode 100644
>> index 0000000..b47329f
>> --- /dev/null
>> +++ b/drivers/devfreq/devfreq-event.c
>> @@ -0,0 +1,302 @@
>> +/*
>> + * devfreq-event: Generic DEVFREQ Event class driver
>> + *
>> + * Copyright (C) 2014 Samsung Electronics
>> + * Chanwoo Choi <cw00.choi@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This driver is based on drivers/devfreq/devfreq.c
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/sched.h>
>> +#include <linux/errno.h>
>> +#include <linux/err.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/stat.h>
>> +#include <linux/pm_opp.h>
>> +#include <linux/devfreq.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/list.h>
>> +#include <linux/printk.h>
>> +#include <linux/hrtimer.h>
>> +#include <linux/of.h>
>> +#include "governor.h"
>> +
>> +static struct class *devfreq_event_class;
>> +
>> +/* The list of all devfreq event list */
>> +static LIST_HEAD(devfreq_event_list);
>> +static DEFINE_MUTEX(devfreq_event_list_lock);
>> +
>> +#define to_devfreq_event(DEV) container_of(DEV, struct devfreq_event_dev, dev)
>> +
>> +struct devfreq_event_dev *devfreq_add_event_device(struct device *dev,
>> +					struct devfreq_event_desc *desc)
>> +{
>> +	struct devfreq_event_dev *event_dev;
>> +	static atomic_t event_no = ATOMIC_INIT(0);
>> +	int ret;
>> +
>> +	if (!dev || !desc)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	if (!desc->name || !desc->ops)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	event_dev = kzalloc(sizeof(struct devfreq_event_dev), GFP_KERNEL);
>> +	if (!event_dev)
>> +		return ERR_PTR(-ENOMEM);
> 
> Is this memory freed anywhere when driver is removed? I couldn't find
> it. I couldn't also find function like devfreq_remove_event_device()
> which would be reverting all the work done when adding.

You're right. I'll use devm_kzalloc instead of kzalloc.

> 
>> +
>> +	mutex_lock(&devfreq_event_list_lock);
>> +
>> +	mutex_init(&event_dev->lock);
>> +	event_dev->desc = desc;
>> +	event_dev->dev.parent = dev;
>> +	event_dev->dev.class = devfreq_event_class;
>> +
>> +	dev_set_name(&event_dev->dev, "event.%d",
>> +		     atomic_inc_return(&event_no) - 1);
>> +	ret = device_register(&event_dev->dev);
>> +	if (ret != 0) {
>> +		put_device(&event_dev->dev);
>> +		goto err;
>> +	}
>> +	dev_set_drvdata(&event_dev->dev, event_dev);
>> +
>> +	/* Add devfreq event device to devfreq_event_list */
>> +	INIT_LIST_HEAD(&event_dev->node);
>> +	list_add(&event_dev->node, &devfreq_event_list);
>> +
>> +	mutex_unlock(&devfreq_event_list_lock);
>> +
>> +	return event_dev;
>> +err:
> 
> Missing 'mutex_unlock(&devfreq_event_list_lock)' here.

OK. I'll fix it.

> 
> 
>> +	kfree(event_dev);
>> +	return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL(devfreq_add_event_device);
>> +
>> +struct devfreq_event_dev *devfreq_get_event_dev(const char *event_dev_name)
>> +{
>> +	struct devfreq_event_dev *event_dev;
>> +
>> +	mutex_lock(&devfreq_event_list_lock);
>> +	list_for_each_entry(event_dev, &devfreq_event_list, node) {
>> +		if (!strcmp(event_dev->desc->name, event_dev_name))
>> +			goto out;
>> +	}
>> +	event_dev = NULL;
>> +out:
>> +	mutex_unlock(&devfreq_event_list_lock);
>> +
>> +	return event_dev;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_get_event_dev);
>> +
>> +struct devfreq_event_dev *devfreq_get_event_dev_by_phandle(struct device *dev,
>> +						      int index)
>> +{
>> +	struct device_node *node;
>> +	struct devfreq_event_dev *event_dev;
>> +
>> +	if (!dev->of_node) {
>> +		dev_err(dev, "device does not have a device node entry\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	node = of_parse_phandle(dev->of_node, "devfreq-events", index);
>> +	if (!node) {
>> +		dev_err(dev, "failed to get phandle in %s node\n",
>> +			dev->of_node->full_name);
>> +		return ERR_PTR(-ENODEV);
>> +	}
>> +
>> +	event_dev = devfreq_get_event_dev(node->name);
>> +	if (!event_dev) {
>> +		dev_err(dev, "unable to get devfreq-event device : %s\n",
>> +			node->name);
> 
> of_node_put() for node obtained with of_parse_phandle().

OK. I'll add it.

> 
>> +		return ERR_PTR(-ENODEV);
>> +	}
>> +
>> +	return event_dev;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_get_event_dev_by_phandle);
>> +
>> +int devfreq_put_event_dev(struct devfreq_event_dev *event_dev)
>> +{
> 
> of_node_put() here to decrement refcnt from of_parse_phandle()?

It is my mistake. I think that devfreq_put_event_dev is not necesssary.
I'll remove it.

> 
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_put_event_dev);
>> +
>> +int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev)
>> +{
>> +	int ret = 0;
>> +
>> +	if (!event_dev || !event_dev->desc)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&event_dev->lock);
>> +	if (event_dev->desc->ops && event_dev->desc->ops->enable) {
>> +		ret = event_dev->desc->ops->enable(event_dev);
>> +		if (ret < 0)
>> +			goto err;
>> +	}
>> +	event_dev->enable_count++;
>> +err:
>> +	mutex_unlock(&event_dev->lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_enable_event_dev);
>> +
>> +int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev)
>> +{
>> +	int ret = 0;
>> +
>> +	if (!event_dev || !event_dev->desc)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&event_dev->lock);
>> +	if (event_dev->enable_count > 0) {
>> +		event_dev->enable_count--;
>> +	} else {
>> +		dev_warn(&event_dev->dev, "unbalanced enable_count\n");
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	if (event_dev->desc->ops && event_dev->desc->ops->disable) {
>> +		ret = event_dev->desc->ops->disable(event_dev);
>> +		if (ret < 0) {
>> +			event_dev->enable_count++;
>> +			goto err;
>> +		}
>> +	}
>> +err:
>> +	mutex_unlock(&event_dev->lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_disable_event_dev);
>> +
>> +bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev)
>> +{
>> +	bool enabled = false;
>> +
>> +	if (!event_dev || !event_dev->desc)
>> +		return enabled;
>> +
>> +	if (!(event_dev->enable_count > 0))
>> +		return enabled;
>> +
>> +	if (event_dev->desc->ops && event_dev->desc->ops->is_enabled)
>> +		enabled = event_dev->desc->ops->is_enabled(event_dev);
>> +
>> +	return enabled;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_is_enabled_event_dev);
>> +
>> +int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev)
> 
> The convention of names you use is not obvious to me. I would expect
> rather devfreq_event_dev_XXX (where XXX is "set_event", "is_enabled"
> etc).
> The one above is good example what is the issue with current convention:
> devfreq_set_event_event_dev
>             ^     ^
> This double "event" looks weird.

You're right. I'll have to fix the function name according to your comment.

> 
>> +{
>> +	if (!event_dev || !event_dev->desc)
>> +		return -EINVAL;
>> +
>> +	if (!devfreq_is_enabled_event_dev(event_dev))
>> +		return -EPERM;
>> +
>> +	if (event_dev->desc->ops && event_dev->desc->ops->set_event)
>> +		return event_dev->desc->ops->set_event(event_dev);
> 
> No mutexes here? What exactly is protected by mutex?

I used the mutex when devfreq-event class read/write the data of devfreq_event_dev structure.

> 
>> +
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_set_event_event_dev);
>> +
>> +int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
>> +				int *total_event)
>> +{
>> +	if (!event_dev || !event_dev->desc)
>> +		return -EINVAL;
>> +
>> +	if (!devfreq_is_enabled_event_dev(event_dev))
>> +		return -EPERM;
>> +
>> +	if (event_dev->desc->ops && event_dev->desc->ops->get_event)
>> +		return event_dev->desc->ops->get_event(event_dev, total_event);
>> +
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL_GPL(devfreq_get_event_event_dev);
>> +
>> +int devfreq_reset_event_dev(struct devfreq_event_dev *event_dev)
>> +{
>> +	if (!event_dev || !event_dev->desc)
>> +		return -EINVAL;
>> +
>> +	if (!devfreq_is_enabled_event_dev(event_dev))
>> +		return -EPERM;
>> +
>> +	if (event_dev->desc->ops && event_dev->desc->ops->reset)
>> +		return event_dev->desc->ops->reset(event_dev);
> 
> Same here, no mutex?

I replied it on previous your question.

Best Regards,
Chanwoo Choi
