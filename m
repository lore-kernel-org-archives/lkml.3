Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbaAHNTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:19:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53125 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbaAHNTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:19:02 -0500
Message-ID: <52CD5010.6030309@ti.com>
Date: Wed, 8 Jan 2014 18:48:08 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <rob.herring@calxeda.com>, <nm@ti.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH V5 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com> <52B168A5.4010202@ti.com> <52BBB614.5010707@ti.com> <52BC6B16.80507@ti.com> <52BD856E.7010609@ti.com> <52C11284.2030500@ti.com> <20140107230733.GD5074@atomide.com> <20140107235514.GG5074@atomide.com>
In-Reply-To: <20140107235514.GG5074@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wednesday 08 January 2014 05:25 AM, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [140107 15:10]:
>> * Sricharan R <r.sricharan@ti.com> [131229 22:30]:
>>> On Friday 27 December 2013 07:19 PM, Sricharan R wrote:
>>>> On Thursday 26 December 2013 11:14 PM, Santosh Shilimkar wrote:
>>>>> On Wednesday 25 December 2013 11:52 PM, Sricharan R wrote:
>>>>>> On Wednesday 18 December 2013 02:49 PM, Sricharan R wrote:
>>>>>>> I have addressed all the comments on this series, can this be merged now ?
>>>>>>>
>>>>>>   Ping..
>>>>>>
>>>>> Thomas has already given his reviewed-by tag so the patches can be
>>>>> taken via arm-soc tree considering OMAP and GIC changes. Can you
>>>>> create a branch with all these patches applied and send it
>>>>> to Tony ?
>>>>>
>>>> Ok, i will send out a branch for this.
>>>>
>>>  
>>>  I have pushed the below branch
>>>
>>> git://github.com/Sricharanti/sricharan.git
>>> branch: crossbar
>>>
>>> This is on top of Tony's linux-omap master branch
>>
>> The linux-omap master branch cannot be used as a base as it
>> contains tons of commit history not in mainline. So I'll
>> manually applied these patches into omap-for-v3.14/crosbar
>> branch.
> 
> Oops, I noticed some errors on these:
> 
> WARNING: drivers/built-in.o(.text+0xcd0): Section mismatch in reference from the function irqcrossbar_init() to the function .init.text:crossbar_of_init()
> The function irqcrossbar_init() references
> the function __init crossbar_of_init().
> This is often because irqcrossbar_init lacks a __init 
> annotation or the annotation of crossbar_of_init is wrong.
> 
> WARNING: drivers/built-in.o(.text+0xcdc): Section mismatch in reference from the function irqcrossbar_init() to the (unknown reference) .init.rodata:(unknown)
> The function irqcrossbar_init() references
> the (unknown reference) __initconst (unknown).
> This is often because irqcrossbar_init lacks a __initconst 
> annotation or the annotation of (unknown) is wrong.
> 
> So I've dropped them for now. Care to fix up those errors and
> base your patches against let's say v3.13-rc5?
> 
   Very Sorry for the section mismatch warning.
   I have fixed it and pushed a new branch below based on v3.13-rc5

   git://github.com/Sricharanti/sricharan.git
   branch: crossbar_3.13_rc5

Regards,
 Sricharan

   
  

