Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbbATMxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:53:13 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40366 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbATMxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:53:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ef-54be4fb3d070
Message-id: <54BE4FB1.3030209@samsung.com>
Date: Tue, 20 Jan 2015 13:53:05 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 04/19] dt-binding: mfd: max77693: Add DT binding
 related macros
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-5-git-send-email-j.anaszewski@samsung.com>
 <20150120111243.GC13701@x1>
In-reply-to: <20150120111243.GC13701@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xy7qb/feFGLTNULTYOGM9q8XRnROZ
	LK5/ec5qMf/IOVaLs01v2C3ufz3KaHF51xw2i61v1jFa9GzYympx99RRNovdu56yWhx+085q
	cWb/SjYHXo+ds+6yexz+upDF4861PWwee+b/YPXo27KK0WPF6u/sHp83yQWwR3HZpKTmZJal
	FunbJXBl3Ln7nL1gK1/F8nt7GBsYP3N3MXJySAiYSLz+uZ0ZwhaTuHBvPVsXIxeHkMBSRomG
	KXPBEkICHxklPt+XB7F5BbQkLqyawQpiswioSpxb8IARxGYTMJT4+eI1E4gtKhAh8ef0PlaI
	ekGJH5PvsXQxcnCICKhInHtjDhJmFtjFJLHvuAaILSwQK/H2yxpWiL2LGSUO/ZzIBpLgFNCQ
	eHZmLxtEg5nEo5Z1zBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswt
	Ls1L10vOz93ECImaLzsYFx+zOsQowMGoxMOrkbMnRIg1say4MvcQowQHs5II71nzfSFCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGJXfvXW7YuPqaJSrvWif+bkJrw5bPlON0NxtcnRD+dkPx28t
	dqg55nrCXiymOmHbTqfJnrVSje3FSq8OJt3x9In0e7lZff/aQzOZni96bK34qsLf4OCaSRaC
	HKe9ly7g4pr08MNVzm1vbqTtL25eebPOTX6BhIZFl7X0zu/3nDPddpyzVtPh91FiKc5INNRi
	LipOBADAq/8eeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 12:12 PM, Lee Jones wrote:
> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>
>> Add macros for max77693 led part related binding.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   include/dt-bindings/mfd/max77693.h |   21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>   create mode 100644 include/dt-bindings/mfd/max77693.h
>>
>> diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
>> new file mode 100644
>> index 0000000..f53e197
>> --- /dev/null
>> +++ b/include/dt-bindings/mfd/max77693.h
>> @@ -0,0 +1,21 @@
>> +/*
>> + * This header provides macros for MAX77693 device binding
>> + *
>> + * Copyright (C) 2014, Samsung Electronics Co., Ltd.
>> + *
>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + */
>> +
>> +#ifndef __DT_BINDINGS_MAX77693_H__
>> +#define __DT_BINDINGS_MAX77693_H
>> +
>> +/* External trigger type */
>> +#define MAX77693_LED_TRIG_TYPE_EDGE	0
>> +#define MAX77693_LED_TRIG_TYPE_LEVEL	1
>> +
>> +/* Boost modes */
>> +#define MAX77693_LED_BOOST_OFF		0
>> +#define MAX77693_LED_BOOST_ADAPTIVE	1
>> +#define MAX77693_LED_BOOST_FIXED	2
>> +
>> +#endif /* __DT_BINDINGS_MAX77693_H */
>
> These look fairly generic.  Do generic LED defines already exist?  If
> not, can they?

I am not entirely sure that they are generic. Different devices
may define different trigger types for low current LEDs and flash
LEDs. Boost modes could also have different semantics.

Regardless of the above we can consider renaming the file to
include/dt-bindings/leds/max77693.h

Bryan - what is your opinion?

-- 
Best Regards,
Jacek Anaszewski
