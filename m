Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKJS2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:28:32 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:4312 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaKJS2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:28:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,354,1413270000"; 
   d="scan'208";a="50524484"
Message-ID: <546103C8.3030905@broadcom.com>
Date: Mon, 10 Nov 2014 10:28:24 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Broadcom Kernel Feedback List" 
	<bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 4/8] ARM: dts: Enable Broadcom Cygnus SoC
References: <sbranden@broadcom.com> <5982323.RDuqIHPULA@wuerfel> <54604A71.1010000@broadcom.com> <2221359.WPjXKG5OT3@wuerfel>
In-Reply-To: <2221359.WPjXKG5OT3@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-10 12:11 AM, Arnd Bergmann wrote:
> On Sunday 09 November 2014 21:17:37 Scott Branden wrote:
>> On 14-11-09 12:38 PM, Arnd Bergmann wrote:
>>> On Sunday 09 November 2014 09:23:11 Greg Kroah-Hartman wrote:
>>>> On Sat, Nov 08, 2014 at 10:49:09PM -0800, Olof Johansson wrote:
>>>>>>>> +/*
>>>>>>>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
>>>>>>>> + *
>>>>>>>> + * Unless you and Broadcom execute a separate written software license
>>>>>>>> + * agreement governing use of this software, this software is licensed
>>>>>>>> to you
>>>>>>>> + * under the terms of the GNU General Public License as
>>>>>>>> + * published by the Free Software Foundation version 2.
>>>>>>>> + *
>>>>>>>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>>>>>>>> + * kind, whether express or implied; without even the implied warranty
>>>>>>>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>>>> + * GNU General Public License for more details.
>>>>>>>
>>>>>>>
>>>>>>> We ask for new DT contents to be added with dual BSD/GPL license, to
>>>>>>> allow for reuse of the DT data structures in other projects as well.
>>>>>>> There's currently a lot of activity going on relicensing the current
>>>>>>> files so I recommend sorting it out before they are added if you can.
>>>>>>
>>>>>>
>>>>>> This may take more time than you think.  I am going to have to go through
>>>>>> legal to get such a license created. Also, why would you need dual license?
>>>>>> If it is BSD that should serve both purposes?
>>>>>
>>>>> I haven't followed the discussion close enough to know if there's been
>>>>> discussion about single-license BSD vs dual BSD/GPL.
>>>
>>> I think for all practical purposes, BSD and dual BSD/GPL is the same and
>>> listing it as dual was meant as a clarification to make it easier to see
>>> that all files in the kernel are GPLv2 compatible.
>> A dual BSD/GPL may involve having me get a lawyer to create such a
>> header.  I would prefer to leave it as GPL for now until some concrete
>> decision has finally been made on this by the rest of the community?
>> Or, I can put it as BSD right now if that helps?
>
> I would prefer a pure BSD header for the moment over a pure GPL header.
> The last thing we want is to force other operating systems to create
> another set of dts files for the same hardware.
I have changed the headers to pure BSD.  I hope this is acceptable.
>
> 	Arnd
>

