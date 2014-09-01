Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaIASaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:30:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42861 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIASaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:30:11 -0400
Message-ID: <5404BB31.3060001@ti.com>
Date: Mon, 01 Sep 2014 13:30:09 -0500
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Keerthy <j-keerthy@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: palmas: Add support for optional wakeup
References: <1408457197-30487-1-git-send-email-nm@ti.com> <20140829105619.GH24579@lee--X1> <54007515.5080506@ti.com> <20140901093206.GJ7374@lee--X1>
In-Reply-To: <20140901093206.GJ7374@lee--X1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 04:32 AM, Lee Jones wrote:
> On Fri, 29 Aug 2014, Nishanth Menon wrote:
>> On 08/29/2014 05:56 AM, Lee Jones wrote:
>>> On Tue, 19 Aug 2014, Nishanth Menon wrote:
>>>
>>>> With the recent pinctrl-single changes, omaps can treat wake-up events
>>>> from deeper idle states as interrupts.
>>>>
>>>> Let's add support for the optional second interrupt for wake-up
>>>> events. And then SoC can wakeup and handle the event using it's
>>>> regular handler.
>>>>
>>>> Finally, to pass the wake-up interrupt in the dts file,
>>>> interrupts-extended property needs to be passed.
>>>>
>>>> This is similar in approach to commit 2a0b965cfb6e ("serial: omap: Add
>>>> support for optional wake-up")
>>>>
>>>> Signed-off-by: Nishanth Menon <nm@ti.com>
>>>> ---
>>>>   Documentation/devicetree/bindings/mfd/palmas.txt |   20 ++++++++
>>>
>>> DT Ack please.
>
> Please read Documentation/devicetree/bindings/submittingpatches.txt

I assume you wanted me to note the following:
"
The Documentation/ portion of the patch should be a separate patch.
"

Many maintainers prefer that when the bindings for the device is new, 
and when additional properties are added, they prefer it part of same 
patch.. Anyways.. if the above is what you prefer, I can follow that.

In short, I assume you'd like three patches:
a) fix up style of current documentation - palmas to palmas@40
b) Split documentation for interrupt-extended from the current patch 
into it's own patch.
c) remainder of this patch as is..

Does that sound right?

---
Regards,
Nishanth Menon


