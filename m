Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3DLMVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:21:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50854 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3DLMVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:21:36 -0400
Message-ID: <5167FC3B.2070200@ti.com>
Date: Fri, 12 Apr 2013 08:21:15 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amit.daniel@samsung.com>,
        <durgadoss.r@intel.com>, <andi@lisas.de>
Subject: Re: [PATCH V2 1/3] Thermal: rename thermal_sys.c to thermal_core.c
References: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>  <1364567196-3560-2-git-send-email-rui.zhang@intel.com>  <515DE192.1030408@ti.com> <1365729176.2183.20.camel@rzhang1-mobl4>
In-Reply-To: <1365729176.2183.20.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-2013 21:12, Zhang Rui wrote:
> On Thu, 2013-04-04 at 16:24 -0400, Eduardo Valentin wrote:
>> On 29-03-2013 10:26, Zhang Rui wrote:
>>> this is the preparation work to build all the thermal core framework
>>> source file, like governors, cpu cooling, etc, into one module.
>>>
>>> No functional change in this patch.
>>>
>>> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>>
>> Durga and me have already reviewed and acked this patch. Can you please
>> add our Acked-by on this patch?
>
> sure.
> BTW, I've talked with Rafael, and we agree on adding prefix "acpi_" for
> ACPI drivers, and then we can rename thermal_sys.ko to thermal.ko.
>

Good!

> But I'll try to push this patch set for 3.10, to fix the problem on
> hand, also for easily back porting to 3.8 and 3.9 stable kernel.
> Then, we'll rename a couple of ACPI drivers and then thermal driver in
> 3.11.
>
> what do you think?

I am OK with this approach.

Thanks for keeping this up.

>
> thanks,
> rui
>
>>
>>> ---
>>>    drivers/thermal/Makefile                          |    1 +
>>>    drivers/thermal/{thermal_sys.c => thermal_core.c} |    0
>>>    2 files changed, 1 insertion(+)
>>>    rename drivers/thermal/{thermal_sys.c => thermal_core.c} (100%)
>>>
>>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>>> index d3a2b38..b2009bd 100644
>>> --- a/drivers/thermal/Makefile
>>> +++ b/drivers/thermal/Makefile
>>> @@ -3,6 +3,7 @@
>>>    #
>>>
>>>    obj-$(CONFIG_THERMAL)		+= thermal_sys.o
>>> +thermal_sys-y			+= thermal_core.o
>>>
>>>    # governors
>>>    obj-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
>>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_core.c
>>> similarity index 100%
>>> rename from drivers/thermal/thermal_sys.c
>>> rename to drivers/thermal/thermal_core.c
>>>
>>
>
>
>
>

