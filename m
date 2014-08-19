Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaHSUzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:55:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39933 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaHSUzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:55:21 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Thread-Topic: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Thread-Index: AQHPuKBG/Qme4vynlkWiIpuXx8CBGw==
Date: Tue, 19 Aug 2014 20:55:14 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DEC525@DFLE09.ent.ti.com>
References: <1408117670-19750-1-git-send-email-dmurphy@ti.com>
 <20140819192401.GA32080@core.coreip.homeip.net>
 <00FC9A978A94B7418C33AFAE8A35ED49DEC1EF@DFLE09.ent.ti.com>
 <20140819200748.GB3626@core.coreip.homeip.net>
 <00FC9A978A94B7418C33AFAE8A35ED49DEC3E6@DFLE09.ent.ti.com>
 <20140819202438.GD3626@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry

On 08/19/2014 03:24 PM, Dmitry Torokhov wrote:
> On Tue, Aug 19, 2014 at 08:13:32PM +0000, Murphy, Dan wrote:
>> On 08/19/2014 03:07 PM, Dmitry Torokhov wrote:
>>> On Tue, Aug 19, 2014 at 07:35:06PM +0000, Murphy, Dan wrote:
>>>> Dmitry
>>>>

<snip>

>>> 	...
>>>
>>> That one I kept.
>>>
>>
>> Yes that is correct but the enable_gpio for non-dt enabled devices this enable_gpio
>> needs to come from the platform data structure.  Without the enable gpio in the platform data
>> structure there is no way for non-dt enabled devices to set the gpio value.
> 
> What else uses the platform data structure? You are accessing gpio by name, not
> by number, in the driver so I am not sure how non-dt case will use u32 defined
> in platform data.
> 
>>
>> The haptics instance just stores the gpio descriptor returned from this call.
> 
> Right.
> 
>>
>> The devm_gpiod looks at the platform data is CONFIG_OF is not set.
> 
> Umm, how? You do not pass it anywhere...

OK I drop my argument after drilling through gpio code.

Removal of this is OK.

Thanks

> 
> Thanks.
> 


-- 
------------------
Dan Murphy
