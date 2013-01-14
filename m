Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3ANJ2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:28:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56322 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab3ANJ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:28:01 -0500
Message-ID: <50F3CF9B.8010608@ti.com>
Date: Mon, 14 Jan 2013 10:27:55 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
References: <1356358796.1688.3.camel@cliu38-desktop-build> <50E162F8.8030403@ti.com> <27240C0AC20F114CBF8149A2696CBE4A203154@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A203154@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

On 01/14/2013 03:18 AM, Liu, Chuansheng wrote:
> Hi maintainers,
> 
> Could you help to push this patch?
> Every time syncing the latest code, always meet this build error.
> Sorry to disturb.

First of all I'm sorry for this, since this is my mistake to not update the
Kconfig file at the same time.
AFAIK Samuel is really busy with Intel stuff (might be worth pinging him
within Intel), but I'm sure he is going to do everything he can to resolve this.
We can ask Greg to take this further as well. Whichever is going to be the faster.

Regards,
Péter

> 
>> -----Original Message-----
>> From: Peter Ujfalusi [mailto:peter.ujfalusi@ti.com]
>> Sent: Monday, December 31, 2012 6:04 PM
>> To: Liu, Chuansheng
>> Cc: sameo@linux.intel.com; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
>>
>> On 12/24/2012 03:19 PM, Chuansheng Liu wrote:
>>> This patch fix the below build error:
>>> drivers/built-in.o: In function `twl_probe':
>>> drivers/mfd/twl-core.c:1256: undefined reference to `devm_regmap_init_i2c'
>>> make: *** [vmlinux] Error 1
>>
>> Thanks Liu, I have missed this one.
>>
>> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>
>>>
>>> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
>>> ---
>>>  drivers/mfd/Kconfig |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>> index 1c0abd4..47ad4e2 100644
>>> --- a/drivers/mfd/Kconfig
>>> +++ b/drivers/mfd/Kconfig
>>> @@ -292,6 +292,7 @@ config TWL4030_CORE
>>>  	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0
>> Support"
>>>  	depends on I2C=y && GENERIC_HARDIRQS
>>>  	select IRQ_DOMAIN
>>> +	select REGMAP_I2C
>>>  	help
>>>  	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
>>>  	  This core driver provides register access and IRQ handling
>>>


