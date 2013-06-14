Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3FNFIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:08:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52606 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3FNFIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:08:32 -0400
X-AuditID: cbfee68e-b7f276d000002279-4c-51baa54e9386
Message-id: <51BAA54E.3000407@samsung.com>
Date: Fri, 14 Jun 2013 14:08:30 +0900
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
Subject: Re: [PATCH] extcon: Add an API to get extcon device from dt node
References: <1370276020-17446-2-git-send-email-kishon@ti.com>
 <1371001149-16906-1-git-send-email-cw00.choi@samsung.com>
 <51B81B50.10508@ti.com>
In-reply-to: <51B81B50.10508@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42JZI2JSpOu3dFegwZzrphaXb3QxWxy8X28x
	89NNNosDsx+yWhz4s4PRonnxejaLC0972CwWti1hsbi8aw6bxewl/SwWi5a1MlvcblzBZvF7
	1zF2i8MrDjBZrHs5ncWB32PB5yvsHjtn3WX3eLV6JqvHnWt72Dz2z13D7nF+xkJGj/PNRxg9
	+rasYvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGXcPbmQpOKlY8ev2CrYGxvtSXYycHBIC
	JhIvfj1jhbDFJC7cW8/WxcjFISSwlFFi1oyZbDBFv3uughUJCUxnlGj/EQ5R9IJR4u6rViaQ
	BK+AlkTv6lNgDSwCqhI3pr0Di7MBxfe/uAEWFxUIk1g5/QoLRL2gxI/J98BsEaCa0zt/MIMM
	ZRb4zCTxtXkNI0hCWMBTYsvX2cwQ2yYzSvT8aQI7g1NAReLt4U1g3cwCOhL7W6exQdjyEpvX
	vAVrkBBYyyFxecVLFoiTBCS+TT4EZHMAJWQlNh1ghnhNUuLgihssExjFZiE5ahaSsbOQjF3A
	yLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzD2T/971reD8eYB60OMyUArJzJLiSbnA1NH
	Xkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYs6Yx
	cm7OC/a+vyHT8sqnAl0Hfv4H67knzWac+OazgXPClF6bEMdPfmfWO0QVs90+KKmSPvONmF1i
	uJZTvtLv9RKnG+YtfbCu7u6LkG2H/j+9Mt3jb/6OOcfk96SkbJQXMRSbs0Pj5OS65ZpzTl87
	vEVKJSBrzr+ylsLDu6a9+/71kFvjklVXfZVYijMSDbWYi4oTARlVtBwTAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQV2/pbsCDbat1ra4fKOL2eLg/XqL
	mZ9uslkcmP2Q1eLAnx2MFs2L17NZXHjaw2axsG0Ji8XlXXPYLGYv6WexWLSsldniduMKNovf
	u46xWxxecYDJYt3L6SwO/B4LPl9h99g56y67x6vVM1k97lzbw+axf+4ado/zMxYyepxvPsLo
	0bdlFaPH8RvbmTw+b5IL4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx
	9+BGloKTihW/bq9ga2C8L9XFyMkhIWAi8bvnKiuELSZx4d56NhBbSGA6o0T7j/AuRi4g+wWj
	xN1XrUwgCV4BLYne1afAilgEVCVuTHsHFmcDiu9/cQMsLioQJrFy+hUWiHpBiR+T74HZIkA1
	p3f+YAYZyizwmUnia/MaRpCEsICnxJavs5khtk1mlOj50wR2EqeAisTbw5vAupkFdCT2t05j
	g7DlJTavecs8gVFgFpIls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGJ5
	JrWDcWWDxSFGAQ5GJR7ehAs7A4VYE8uKK3MPMUpwMCuJ8Ib/BQrxpiRWVqUW5ccXleakFh9i
	TAaGwURmKdHkfGDSyyuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGxogd9lMmV62Jef4g4egWdoH4Ry/8S//e/i7Du2qTrM7nAytbTs7QX3t9oWZp7HmTNTYP
	duzKLG4MF50s/XnyMt1OhXP8TzbLmlmU/H544zSbcX4b26R7az7JhGjfPZDiyz//4pqWnqCd
	wi9unAnR2cro4PtY3Ht1yM3gv76mZivMo1vTZCeHJyuxFGckGmoxFxUnAgCj2RBecAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 03:55 PM, Kishon Vijay Abraham I wrote:
> Hi Chanwoo Choi,
> 
> On Wednesday 12 June 2013 07:09 AM, Chanwoo Choi wrote:
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
>>   drivers/extcon/Makefile          |  3 +++
>>   drivers/extcon/of-extcon.c       | 56 ++++++++++++++++++++++++++++++++++++++++
>>   include/linux/extcon/of-extcon.h | 30 +++++++++++++++++++++
>>   3 files changed, 89 insertions(+)
>>   create mode 100644 drivers/extcon/of-extcon.c
>>   create mode 100644 include/linux/extcon/of-extcon.h
>>
>> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
>> index 540e2c3..39cdf95 100644
>> --- a/drivers/extcon/Makefile
>> +++ b/drivers/extcon/Makefile
>> @@ -2,9 +2,12 @@
>>   # Makefile for external connector class (extcon) devices
>>   #
>>
>> +obj-$(CONFIG_OF)        += of-extcon.o
>> +
>>   obj-$(CONFIG_EXTCON)        += extcon-class.o
>>   obj-$(CONFIG_EXTCON_GPIO)    += extcon-gpio.o
>>   obj-$(CONFIG_EXTCON_ADC_JACK)    += extcon-adc-jack.o
>> +
>>   obj-$(CONFIG_EXTCON_MAX77693)    += extcon-max77693.o
>>   obj-$(CONFIG_EXTCON_MAX8997)    += extcon-max8997.o
>>   obj-$(CONFIG_EXTCON_ARIZONA)    += extcon-arizona.o
>> diff --git a/drivers/extcon/of-extcon.c b/drivers/extcon/of-extcon.c
>> new file mode 100644
>> index 0000000..29f82b4
>> --- /dev/null
>> +++ b/drivers/extcon/of-extcon.c
>> @@ -0,0 +1,56 @@
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
>> +#include <linux/extcon.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/extcon/of-extcon.h>
>> +
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
> 
> In order to get this working, I needed a small fix in extcon_dev_register
> 
> -       dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
> +       edev->name = edev->name ? edev->name : dev_name(dev);
> +       dev_set_name(edev->dev, edev->name);
> 

OK, I added it on this patch.

> Also using extcon_get_extcon_dev here requires the extcon driver not to set edev.name since we use *dev_name* here. Hence I recommend using my initial class iterative approach. Anyway its your call. Let me know if have to float a new version of the patch (either the iterative approach or having the fix I mentioned in extcon_dev_register).

I prefer to imprement "of_extcon_get_extcon_dev()" separately from extcon core.

I will resend modified patch with your comment of extcon_dev_register() at once.

Thanks,
Chanwoo Choi
