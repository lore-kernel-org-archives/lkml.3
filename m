Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaDRAM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:12:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39852 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDRAM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:12:27 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-16-53506dea1015
Message-id: <53506DF0.8050209@samsung.com>
Date: Fri, 18 Apr 2014 09:12:32 +0900
From: Sangjung <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cwchoi00@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCHv2 1/8] extcon: Add resource-managed extcon register function
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
 <1397729403-32045-2-git-send-email-sangjung.woo@samsung.com>
 <CAGTfZH1YtzQ0jZS3N-JgX8GYzSx753v_yO0dYM_E+B1bnJvqEQ@mail.gmail.com>
In-reply-to: <CAGTfZH1YtzQ0jZS3N-JgX8GYzSx753v_yO0dYM_E+B1bnJvqEQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkWPdVbkCwwY3DqhbXvzxntXh2VNvi
	9QtDi8u75rBZ3G5cwWYxY/JLNgc2j52z7rJ79G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8b1
	KydYCt5rVTzsfcXcwNij2MXIziEhYCLxoaSLkRPIEpO4cG89WxcjF4eQwFJGicb+DUAOB1jJ
	5DUZEPHpjBIfX29ghXBeM0r87P7JDtLNK6AlsbP1DCPITBYBVYnZ3iBRNgFNic/HD7KB2KIC
	ERJzJ25mg6gWlPgx+R4LiC0CVD3lXic7yEhmgbuMEkuevGYESQgLBEjs+fOdEWLXOUaJ23vO
	MIEcxCkQLHHwpR1IDbOAmcSjlnXMELa8xOY1b5lB6iUE9rFL3OzuZQVJsAgISHybfIgF4hlZ
	iU0HmCEelpQ4uOIGywRGsVlIbpqFZOwsJGMXMDKvYhRNLUguKE5KLzLUK07MLS7NS9dLzs/d
	xAiMp9P/nvXuYLx9wPoQYzLQyonMUqLJ+cB4zCuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRjelwhnmT6QnOm70Cl4cuTjR+VPcx/7MV+r3ZR41
	e0W5fPn9/MMyRrsjj7ItXp7/OSXVIzvSYp60yxK7J/Z5IQETn08yznlUfPW2X2Lsrzxnp4ch
	E//7ufJUZv/X0T2zSGzGbjfep3yTmF96sbKab+uJ3sHbH765/8Lbf2HVF/wbz1V0WxXuVGIp
	zkg01GIuKk4EAG1dPEm9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO6r3IBgg6PfZSyuf3nOavHsqLbF
	6xeGFpd3zWGzuN24gs1ixuSXbA5sHjtn3WX36NuyitHj8ya5AOaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCGsaM61dOsBS816p42PuKuYGxR7GLkYNDQsBEYvKajC5GTiBT
	TOLCvfVsXYxcHEIC0xklPr7ewArhvGaU+Nn9kx2kildAS2Jn6xnGLkZ2DhYBVYnZ3iBRNgFN
	ic/HD7KB2KICERJzJ25mg6gWlPgx+R4LiC0CVD3lXic7yEhmgbuMEkuevGYESQgLBEjs+fOd
	EWLXOUaJ23vOMIEcxykQLHHwpR1IDbOAmcSjlnXMELa8xOY1b5knMArMQrJjFpKyWUjKFjAy
	r2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjthn0jsYVzVYHGIU4GBU4uG98NU/WIg1say4
	MvcQowQHs5II7/m0gGAh3pTEyqrUovz4otKc1OJDjMnAAJjILCWanA9MJnkl8YbGJmZGlkbm
	hhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMj0plLMvldc4gD3Y2H/OrHsyWEc
	XAtkvnmaL72Y8Vvtd9gjy+86Z+bw7BOwWLpld8yO5ZdZGnx3PDOXYRZfKpdxe8JaLQNRydsC
	VVElSd+K7pg91WH67rrSdF1MzkyRqUd3LVcsWi4lLbLmj7xrnd+FvszTWeJeJ7PlRD1172Sk
	XPttltw1Q4mlOCPRUIu5qDgRAG/sXQccAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo


On 04/18/2014 12:26 AM, Chanwoo Choi wrote:
> Hi Sangjung,
>
> This patch(v2) is same as previous patch(v1).
> I think you sent previous patch(v1) instead of v2.

You're right. I made a big mistake.
I will send the fixed one as v3.

Thank you.
Sangjung

>
> Thanks
> Chanwoo Choi
>
> On Thu, Apr 17, 2014 at 7:09 PM, Sangjung Woo <sangjung.woo@samsung.com> wrote:
>> Add resource-managed extcon device register function for convenience.
>> For example, if a extcon device is attached with new
>> devm_extcon_dev_register(), that extcon device is automatically
>> unregistered on driver detach.
>>
>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>> ---
>>   drivers/extcon/extcon-class.c |   83 +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/extcon.h        |    8 ++++
>>   2 files changed, 91 insertions(+)
>>
>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>> index 7ab21aa..accb49c 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -32,6 +32,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/sysfs.h>
>>   #include <linux/of.h>
>> +#include <linux/gfp.h>
>>
>>   /*
>>    * extcon_cable_name suggests the standard cable names for commonly used
>> @@ -819,6 +820,88 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>>   }
>>   EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>>
>> +
>> +/*
>> + * Device resource management
>> + */
>> +
>> +struct extcon_devres {
>> +       struct extcon_dev *edev;
>> +};
>> +
>> +static void devm_extcon_release(struct device *dev, void *res)
>> +{
>> +       struct extcon_devres *dr = (struct extcon_devres *)res;
>> +
>> +       extcon_dev_unregister(dr->edev);
>> +}
>> +
>> +static int devm_extcon_match(struct device *dev, void *res, void *data)
>> +{
>> +       struct extcon_devres *dr = (struct extcon_devres *)res;
>> +       struct extcon_devres *match = (struct extcon_devres *)data;
>> +
>> +       return dr->edev == match->edev;
>> +}
>> +
>> +/**
>> + * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
>> + * @dev:       device to allocate extcon device
>> + * @edev:      the new extcon device to register
>> + *
>> + * Managed extcon_dev_register() function. If extcon device is attached with
>> + * this function, that extcon device is automatically unregistered on driver
>> + * detach. Internally this function calls extcon_dev_register() function.
>> + * To get more information, refer that function.
>> + *
>> + * If extcon device is registered with this function and the device needs to be
>> + * unregistered separately, devm_extcon_dev_unregister() should be used.
>> + *
>> + * RETURNS:
>> + * 0 on success, negative error number on failure.
>> + */
>> +int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
>> +{
>> +       struct extcon_devres *dr;
>> +       int rc;
>> +
>> +       dr = devres_alloc(devm_extcon_release, sizeof(struct extcon_devres),
>> +                       GFP_KERNEL);
>> +       if (!dr)
>> +               return -ENOMEM;
>> +
>> +       rc = extcon_dev_register(edev);
>> +       if (rc) {
>> +               devres_free(dr);
>> +               return rc;
>> +       }
>> +
>> +       dr->edev = edev;
>> +       devres_add(dev, dr);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_extcon_dev_register);
>> +
>> +/**
>> + * devm_extcon_dev_unregister() - Resource-managed extcon_dev_unregister()
>> + * @dev:       device the extcon belongs to
>> + * @edev:      the extcon device to unregister
>> + *
>> + * Unregister extcon device that is registered with devm_extcon_dev_register()
>> + * function.
>> + */
>> +void devm_extcon_dev_unregister(struct device *dev, struct extcon_dev *edev)
>> +{
>> +       struct extcon_devres match_dr = { edev };
>> +
>> +       WARN_ON(devres_destroy(dev, devm_extcon_release,
>> +                       devm_extcon_match, &match_dr));
>> +
>> +       extcon_dev_unregister(edev);
>> +}
>> +EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
>> +
>>   #ifdef CONFIG_OF
>>   /*
>>    * extcon_get_edev_by_phandle - Get the extcon device from devicetree
>> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
>> index f488145..e1e85a1 100644
>> --- a/include/linux/extcon.h
>> +++ b/include/linux/extcon.h
>> @@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
>>   extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
>>
>>   /*
>> + * Resource-managed extcon device register function.
>> + */
>> +extern int devm_extcon_dev_register(struct device *dev,
>> +                               struct extcon_dev *edev);
>> +extern void devm_extcon_dev_unregister(struct device *dev,
>> +                               struct extcon_dev *edev);
>> +
>> +/*
>>    * get/set/update_state access the 32b encoded state value, which represents
>>    * states of all possible cables of the multistate port. For example, if one
>>    * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

