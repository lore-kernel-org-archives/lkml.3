Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaICSvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:51:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45575 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaICSvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:51:08 -0400
Message-ID: <54076311.2030306@ti.com>
Date: Wed, 3 Sep 2014 13:50:57 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>, <linux-omap@vger.kernel.org>
Subject: Re: PROBLEM: bindings for drivers/mfd/twl4030-power.c
References: <FAC7D7E5-1D05-4D63-821F-C56D3AAA8FF9@goldelico.com> <20140825212652.GR17254@atomide.com> <EBD1E2E6-E596-4B3D-B093-144ABDD7DEDE@goldelico.com> <20140903184527.GG11766@atomide.com>
In-Reply-To: <20140903184527.GG11766@atomide.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 01:45 PM, Tony Lindgren wrote:
> * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140901 09:54]:
>> Hi,
>>
>> Am 25.08.2014 um 23:26 schrieb Tony Lindgren:
>>
>>> * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140817 08:46]:
>>>> I am trying to make ti,use_poweroff work on 3.17-rc1 for the GTA04 board.
>>>> Poweroff was broken for a while and I found that the driver isn't loaded at all.
>>>>
>>>> It appears to me that commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
>>>> did rename the compatible entry from "ti,twl4030-power" to "ti,twl4030-power-reset"
>>>> but this was not documented in the bindings and of course our DT does not
>>>> match.
>>>>
>>>> Even your commit message talks about "ti,twl4030-power" although I can't find it
>>>> in the code.
>>>
>>> Hmm sorry did I accidentally remove ti,twl4030-power? If so, that should
>>> be added back for sure. Do you have a patch for that already?
>>
>> No, I have only updated our device tree because I don't know if it really should
>> be added back or not.
>>
>> As you say the "ti,twl4030-power" does not configure anything. So what
>> is it good for?
> 
> Only for the poweroff if "ti,use_poweroff" is set. Care to do a patch
> as you clearly have a use case to test it with?

Tony, we were talking about supporting ti,system-power-controller as
the standard way of stating poweroff control is by the PMIC. this
seems to be standard in various SoCs. use_poweroff seems to predate
that standardization. Should'nt we start using
ti,system-power-controller instead?

-- 
Regards,
Nishanth Menon
