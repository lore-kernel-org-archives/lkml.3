Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaIBWXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:23:08 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63098 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaIBWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:23:06 -0400
Message-ID: <54064323.3090406@gmail.com>
Date: Tue, 02 Sep 2014 15:22:27 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Brian Norris <computersforpeace@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Matt Porter <mporter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v8 03/11] ARM: brcmstb: add debug UART for earlyprintk
 support
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>	<1405976886-27807-4-git-send-email-computersforpeace@gmail.com>	<20140802083040.GY30282@n2100.arm.linux.org.uk>	<20140804165627.GT3711@ld-irv-0074>	<CAN8TOE8w5bUT5byHiJrYr8AzaZ+EADzE+aoH6f2x2tFc1+1eQw@mail.gmail.com> <CAOesGMh5wX5eaCmPvXQs4fmNQsD+370P=O8PSdH2oMHKL_neDQ@mail.gmail.com>
In-Reply-To: <CAOesGMh5wX5eaCmPvXQs4fmNQsD+370P=O8PSdH2oMHKL_neDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 03:16 PM, Olof Johansson wrote:

[snip]

>>>> I noticed that you sent this to the patch system.  I asked Olof last
>>>> night whether he had anything in arm-soc touching Kconfig.debug, and
>>>> he does (a number of other platforms have updated it.)  This means
>>>> that if I apply it to my tree, it may conflict, so I'm reluctant to
>>>> take it.
>>>
>>> OK... Matt told me that such patches go through you. So which is it?
>>> Should all Kconfig.debug patches go through the arm-soc route?
>>
>> How should this get in? Should I rebase/resend through Matt and
>> arm-soc? Or can you pick this up as-is?
> 
> Kconfig.debug is something that we usually merge new platforms for
> through arm-soc. The main exception has been release cycles when
> Russell has been doing major surgery on the file (one of those was a
> few releases ago), where we've backed off to avoid conflicts.
> 
> That's been the assumed arrangement from our side at least, we haven't
> had anything more formal than that.
> 
> So, go ahead and send it through us -- if we end up having a cycle
> where we can't apply it we can send it over to Russell for you.

It looks like somehow, this patch got lost somewhere in the submission
process. Is it too late to accept it for 3.17 if we were to re-submit it?

Thanks
--
Florian

