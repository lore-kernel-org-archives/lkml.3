Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab3FNIvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:51:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38806 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3FNIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:51:20 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-2a-51bad9867ca2
Message-id: <51BAD986.30308@samsung.com>
Date: Fri, 14 Jun 2013 17:51:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, anish198519851985@gmail.com,
        pmeerw@pmeerw.net
Subject: Re: [PATCH v2] extcon: Add an API to get extcon device from dt node
References: <1370276020-17446-2-git-send-email-kishon@ti.com>
 <1371194146-17260-1-git-send-email-cw00.choi@samsung.com>
 <51BAD611.1070306@ti.com>
In-reply-to: <51BAD611.1070306@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWyRsSkWLft5q5Ag8tX1Cwu3+hitjh4v95i
	5qebbBYHZj9ktTjwZwejRfPi9WwWF572sFksbFvCYnF51xw2i9lL+lksFi1rZba43biCzeL3
	rmPsFodXHGCyWPdyOosDv8eCz1fYPXbOusvu8Wr1TFaPO9f2sHnsn7uG3eP8jIWMHuebjzB6
	9G1Zxehx/MZ2Jo/Pm+QCuKK4bFJSczLLUov07RK4Mr61ihccMaiYsmwXWwPjdbUuRk4OCQET
	iWNv97ND2GISF+6tZ+ti5OIQEljKKLGobzsrTNGkWb+hEtMZJbav/QHWISTwglHi39tQEJtX
	QEPi45QZQHEODhYBVYm2DxYgYTYBLYn9L26wgdiiAmESK6dfYYEoF5T4MfkemC0CVHN65w9m
	kPnMAp+ZJL42r2EESQgL+Ej8ufWWBWLXVEaJ/Zs1QGxOATWJ1jvvmUFsZgEdif2t09ggbHmJ
	zWvegg2SEFjLIXH01kWwQ1kEBCS+TT7EAnKchICsxKYDzBCPSUocXHGDZQKj2CwkN81CMnYW
	krELGJlXMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgRG/el/z3p3MN4+YH2IMRlo5URmKdHk
	fGDSyCuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	45moTX2Vl3p6vxZemVm0aab/nGWTPFVNr39Lse5aIr3UoV1FJaR4TtD1aCXWcP5Q/2vypx/O
	NlP2sWBbsTXuwOfCtEUz3n6a3XBo2YmeW5K/g/xFVpU+W6yWmxa/fc7nBWVsLBEbTmR52K1/
	kXVEz/C0iv9ck9ZbixRF+o4skf11dLH33A9/JyuxFGckGmoxFxUnAgAY8svwEAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd22m7sCDWbsl7G4fKOL2eLg/XqL
	mZ9uslkcmP2Q1eLAnx2MFs2L17NZXHjaw2axsG0Ji8XlXXPYLGYv6WexWLSsldniduMKNovf
	u46xWxxecYDJYt3L6SwO/B4LPl9h99g56y67x6vVM1k97lzbw+axf+4ado/zMxYyepxvPsLo
	0bdlFaPH8RvbmTw+b5IL4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx
	rVW84IhBxZRlu9gaGK+rdTFyckgImEhMmvWbDcIWk7hwbz2QzcUhJDCdUWL72h/sIAkhgReM
	Ev/ehoLYvAIaEh+nzACKc3CwCKhKtH2wAAmzCWhJ7H9xA2yOqECYxMrpV1ggygUlfky+B2aL
	ANWc3vmDGWQ+s8BnJomvzWsYQRLCAj4Sf269ZYHYNZVRYv9mDRCbU0BNovXOe2YQm1lAR2J/
	6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	p5Rn0jsYVzVYHGIU4GBU4uFNuLAzUIg1say4MvcQowQHs5IIb/hfoBBvSmJlVWpRfnxRaU5q
	8SHGZGAITGSWEk3OB6a7vJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFs
	YeLglGpgZFuzWjstJOPv2wQ2085b2m9vlumtzo85fiX8/YmJxjbz2jyL+EKfqbv+fi58U6km
	SbjOguXHgb9C4ucmF0xU865Yv2Tiv9bA+ocR+580GMj5T7E5XuYaNi2u4sCb92fVziu8VU4v
	kH2w26eFmfP9R4Mmg4JHp4MizjrzKvB8rZB8nDSRoVxbiaU4I9FQi7moOBEAqgauAW0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 05:36 PM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 14 June 2013 12:45 PM, Chanwoo Choi wrote:
>> From: Kishon Vijay Abraham I <kishon@ti.com>
>>
>> Added an API of_extcon_get_extcon_dev() to be used by drivers to get
>> extcon device in the case of dt boot (this can be used instead of
>> extcon_get_extcon_dev()).
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> ---
>> Changes since v1:
>> - If edev->name is NULL, dev_name(dev) is used as edev->name.
>> - Change filename from of-extcon.* to of_extcon.*
>> - Fix build error when CONFIG_OF is not set
>> - Add header file(linux/err.h) to of_extcon.c
>>
>>   drivers/extcon/Makefile          |  2 ++
>>   drivers/extcon/extcon-class.c    |  3 +-
>>   drivers/extcon/of_extcon.c       | 64 ++++++++++++++++++++++++++++++++++++++++
>>   include/linux/extcon/of_extcon.h | 30 +++++++++++++++++++
>>   4 files changed, 98 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/extcon/of_extcon.c
>>   create mode 100644 include/linux/extcon/of_extcon.h
>>
>> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
>> index 540e2c3..83468f7 100644
>> --- a/drivers/extcon/Makefile
>> +++ b/drivers/extcon/Makefile
>> @@ -2,6 +2,8 @@
>>   # Makefile for external connector class (extcon) devices
>>   #
>>
>> +obj-$(CONFIG_OF)        += of_extcon.o
>> +
>>   obj-$(CONFIG_EXTCON)        += extcon-class.o
>>   obj-$(CONFIG_EXTCON_GPIO)    += extcon-gpio.o
>>   obj-$(CONFIG_EXTCON_ADC_JACK)    += extcon-adc-jack.o
>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>> index 23f11ea..08509ea 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -602,7 +602,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
>>       edev->dev->class = extcon_class;
>>       edev->dev->release = extcon_dev_release;
>>
>> -    dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
>> +    edev->name = edev->name ? edev->name : dev_name(dev);
>> +    dev_set_name(edev->dev, edev->name);
>>
>>       if (edev->max_supported) {
>>           char buf[10];
>> diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
>> new file mode 100644
>> index 0000000..72173ec
>> --- /dev/null
>> +++ b/drivers/extcon/of_extcon.c
>> @@ -0,0 +1,64 @@
>> +/*
>> + * OF helpers for External connector (extcon) framework
>> + *
>> + * Copyright (C) 2013 Texas Instruments, Inc.
>> + * Kishon Vijay Abraham I <kishon@ti.com>
>> + *
>> + * Copyright (C) 2013 Samsung Electronics
>> + * Chanwoo Choi <cw00.choi@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/extcon.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/extcon/of_extcon.h>
>> +
>> +/*
>> + * of_extcon_get_extcon_dev - Get the name of extcon device from devicetree
>> + * @dev - instance to the given device
>> + * @index - index into list of extcon_dev
>> + *
>> + * return the instance of extcon device
>> + */
>> +struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
>> +{
>> +    struct device_node *node;
>> +    struct extcon_dev *edev;
>> +    struct platform_device *extcon_parent_dev;
>> +
>> +    if (!dev->of_node) {
>> +        dev_dbg(dev, "device does not have a device node entry\n");
>> +        return ERR_PTR(-EINVAL);
>> +    }
>> +
>> +    node = of_parse_phandle(dev->of_node, "extcon", index);
>> +    if (!node) {
>> +        dev_dbg(dev, "failed to get phandle in %s node\n",
>> +            dev->of_node->full_name);
>> +        return ERR_PTR(-ENODEV);
>> +    }
>> +
>> +    extcon_parent_dev = of_find_device_by_node(node);
>> +    if (!extcon_parent_dev) {
>> +        dev_dbg(dev, "unable to find device by node\n");
>> +        return ERR_PTR(-EPROBE_DEFER);
>> +    }
>> +
>> +    edev = extcon_get_extcon_dev(dev_name(&extcon_parent_dev->dev));
>> +    if (!edev) {
>> +        dev_dbg(dev, "unable to get extcon device : %s\n",
>> +                dev_name(&extcon_parent_dev->dev));
>> +        return ERR_PTR(-ENODEV);
>> +    }
>> +
>> +    return edev;
>> +}
>> +EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
>> diff --git a/include/linux/extcon/of_extcon.h b/include/linux/extcon/of_extcon.h
>> new file mode 100644
>> index 0000000..462f071
>> --- /dev/null
>> +++ b/include/linux/extcon/of_extcon.h
>> @@ -0,0 +1,30 @@
>> +/*
>> + * OF helpers for External connector (extcon) framework
>> + *
>> + * Copyright (C) 2013 Texas Instruments, Inc.
>> + * Kishon Vijay Abraham I <kishon@ti.com>
>> + *
>> + * Copyright (C) 2013 Samsung Electronics
>> + * Chanwoo Choi <cw00.choi@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef __LINUX_OF_EXTCON_H
>> +#define __LINUX_OF_EXTCON_H
>> +
>> +#if defined(CONFIG_OF) && defined(CONFIG_EXTCON)
>> +extern struct extcon_dev
>> +    *of_extcon_get_extcon_dev(struct device *dev, int index);
>> +#else
>> +static inline struct extcon_dev
>> +    *of_extcon_get_extcon_dev(struct device *dev, int index)
>> +{
>> +    return NULL;
> 
> Can we have some error value returned here instead of NULL?
> ERR_PTR(-ENOSYS)?
> 

OK, I modified it.

You can check modified patch on below git repo:
http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=2ae384a41c25d6ff8f12091c426fc7324141096f

Thanks,
Chanwoo Choi

