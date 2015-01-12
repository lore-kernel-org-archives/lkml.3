Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbbALIzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:55:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47934 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbALIzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:55:39 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-85-54b38c07e6e3
Message-id: <54B38C07.2010801@samsung.com>
Date: Mon, 12 Jan 2015 17:55:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv7 03/10] devfreq: event: Add resource-managed function for
 devfreq-event device
References: <765071676.891461421049614417.JavaMail.weblogic@epmlwas09a>
In-reply-to: <765071676.891461421049614417.JavaMail.weblogic@epmlwas09a>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkSJejZ3OIwZUPrBaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJusWrXH0YHfo8189YweuycdZfdY/Gel0wem1Z1snlsXlLv0bdlFaPH501yAexR
	XDYpqTmZZalF+nYJXBnPPvewFqyTrfjVvoa1gXGeRBcjJ4eEgInEm53vGCFsMYkL99azdTFy
	cQgJLGWU+NC4mB2mqKvnGVRiEaNEy4c/LBDOa0aJHWe/gLXzCmhJbN0xAaiDg4NFQFXiwrtI
	kDAbUHj/ixtsILaoQJjEyulXWCDKBSV+TL4HZosIyEhc3bgdbCazQC+bxLv1i5hBEsICqRKb
	1i0Fs4UE3CX+bN4AZnMKeEhc+9bCCmIzC6hLTJoHUc8sIC+xec1bZpBBEgJTOST2nnwDtplF
	QEDi2+RDLCDHSQjISmw6wAzxmaTEwRU3WCYwis1CctMsJGNnIRm7gJF5FaNoakFyQXFSepGJ
	XnFibnFpXrpecn7uJkZgZJ/+92zCDsZ7B6wPMQpwMCrx8FpIbQ4RYk0sK67MPcRoCnTFRGYp
	0eR8YPrIK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	Y3TfvrXxIceWLe8snGt6QUP4pPaxI7pWyZez1vE05fUVzs5e6H2IbVO31ob/h5iWN7VMSPxs
	F/PapufBbKWiw9/j3ukovPxo8ZN9qWRd+Nn1YkWpb91+z6irW6uy4DKXxMaDSW+E1cIji17o
	yXwMe9Uj8WdleO6NhR5i+5KvHI0VsRSL5ZI7pcRSnJFoqMVcVJwIAOaOotHnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV32ns0hBl2PLC0er1nMZLFxxnpW
	i0n3J7BYvH5haNH/+DWzxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyWHr9IpPF7cYVbBaP
	V7xlt2jde4TdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Nq3qZPPYvKTeo2/LKkaPz5vkAtij
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DuVlIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmPPvcw1qwTrbiV/sa1gbGeRJd
	jJwcEgImEl09z9ggbDGJC/fWA9lcHEICixglWj78YYFwXjNK7Dj7hRGkildAS2LrjgnsXYwc
	HCwCqhIX3kWChNmAwvtf3AAbJCoQJrFy+hUWiHJBiR+T74HZIgIyElc3bgebySzQyybxbv0i
	ZpCEsECqxKZ1S8FsIQF3iT+bN4DZnAIeEte+tbCC2MwC6hKT5kHUMwvIS2xe85Z5AqPALCQ7
	ZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4LTxTGoH48oGi0OMAhyMSjy8
	FlKbQ4RYE8uKK3MPMUpwMCuJ8LqWAYV4UxIrq1KL8uOLSnNSiw8xmgJDYCKzlGhyPjCl5ZXE
	GxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1MB7v4q3U7pXX36xWMDvu
	BOPqe+x7A5e/ud3xWmmiR99JyZvez+u9tp6P3uNw+eS8XyF/QuyvVC5ZYf2a+WlmSkzY8hNq
	rr9LDuwoWHVDaN+cre4/jW7xzzDt3vze+cdLgw3KG+Zc92uMMGjJONMj0tRwV6FPf+bd6Yv2
	eLwuPPKK65bhk9C4lz+UWIozEg21mIuKEwHOrAREMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

Thanks for your review.

On 01/12/2015 05:00 PM, MyungJoo Ham wrote:
>>   
>>  This patch add the resource-managed function for devfreq-event device as
>> following functions. The devm_devfreq_event_add_edev() manages automatically
>> the memory of devfreq-event device using resource management.
>> - devm_devfreq_event_add_edev()
>> - devm_devfreq_event_remove_edev()
>>
>> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/devfreq-event.c | 63 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/devfreq-event.h   | 16 +++++++++++
>>  2 files changed, 79 insertions(+)
>>
>> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
>> index 64c1764..5301e2b 100644
>> --- a/drivers/devfreq/devfreq-event.c
>> +++ b/drivers/devfreq/devfreq-event.c
>> @@ -451,6 +451,69 @@ int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
>>  }
>>  EXPORT_SYMBOL_GPL(devfreq_event_remove_edev);
>>  
>> +static int devm_devfreq_event_match(struct device *dev, void *res, void *data)
>> +{
>> +	struct devfreq_event_dev **r = res;
>> +
>> +	if (WARN_ON(!r || !*r))
>> +		return 0;
>> +
>> +	return *r == data;
>> +}
>> +
>> +static void devm_devfreq_event_release(struct device *dev, void *res)
>> +{
>> +	devfreq_event_remove_edev(*(struct devfreq_event_dev **)res);
>> +}
> 
> Isn't dev-free functions supposed to check if it is already freed or not?

The devfreq_event_remove_edev() function check whether res is NULL or not.
If some instance of devfreq_event_dev is freeed, devfreq_event_remove_edev()
just return.

> 
>> +
>> +/**
>> + * devm_devfreq_event_add_edev() - Resource-managed devfreq_event_add_edev()
>> + * @dev		: the device owning the devfreq-event device being created
>> + * @desc	: the devfreq-event device's decriptor which include essential
>> + *		  data for devfreq-event device.
>> + *
>> + * Note that this function manages automatically the memory of devfreq-event
>> + * device using device resource management and simplify the free operation
>> + * for memory of devfreq-event device.
>> + */
>> +struct devfreq_event_dev *devm_devfreq_event_add_edev(struct device *dev,
>> +						struct devfreq_event_desc *desc)
>> +{
>> +	struct devfreq_event_dev **ptr, *edev;
>> +
>> +	ptr = devres_alloc(devm_devfreq_event_release, sizeof(*ptr), GFP_KERNEL);
>> +	if (!ptr)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	edev = devfreq_event_add_edev(dev, desc);
>> +	if (IS_ERR(edev)) {
>> +		devres_free(ptr);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	*ptr = edev;
>> +	devres_add(dev, ptr);
>> +
>> +	return edev;
>> +}
>> +EXPORT_SYMBOL(devm_devfreq_event_add_edev);
> 
> You are using GPL Symbol in this function (devres_alloc).

I'll fix it. (EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL).

> 
>> +
>> +/**
>> + * devm_devfreq_event_remove_edev()- Resource-managed devfreq_event_remove_edev()
>> + * @dev		: the device owning the devfreq-event device being created
>> + * @edev	: the devfreq-event device
>> + *
>> + * Note that this function manages automatically the memory of devfreq-event
>> + * device using device resource management.
>> + */
>> +void devm_devfreq_event_remove_edev(struct device *dev,
>> +				struct devfreq_event_dev *edev)
>> +{
>> +	WARN_ON(devres_release(dev, devm_devfreq_event_release,
>> +			       devm_devfreq_event_match, edev));
>> +}
>> +EXPORT_SYMBOL(devm_devfreq_event_remove_edev);
> 
> Here you are using GPL symbol as well (devres_release).

I'll fix it. (EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL).

Best Regards,
Chanwoo Choi

