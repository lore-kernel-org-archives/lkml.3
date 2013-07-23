Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3GWJOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:14:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51804 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3GWJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:14:30 -0400
Message-ID: <51EE496C.3010905@ti.com>
Date: Tue, 23 Jul 2013 14:44:20 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-7-git-send-email-bigeasy@linutronix.de> <51EE1CD2.6080406@ti.com> <51EE4852.7050606@linutronix.de>
In-Reply-To: <51EE4852.7050606@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/2013 2:39 PM, Sebastian Andrzej Siewior wrote:
> On 07/23/2013 08:04 AM, George Cherian wrote:
>> Hi Sebastian,
>>
>>   
>> On 7/22/2013 11:39 PM, Sebastian Andrzej Siewior wrote:
>>
>>> This patch renames the type struct from ti81xx_driver_data to
>>> am33xx_driver_data since it is not used for ti81xx anymore. The EOI
>>> member is also removed since the am33xx SoC does not have such register.
>>> The interrupt is acknowledged by writting into the stat register.
>>>
>> AM335X TRM Section 16.6.5 and 16.7.5 describes about EOI registers.
>> Its at offset 0x24. Or is it that the interrupts are acknowledged even
>> without writing to eoi register?
> I have here "Literature Number: SPRUH73H October 2011 ­ Revised April
> 2013" which calls itself "AM335x ARM® CortexTM-A8 Microprocessors
> (MPUs) Technical Reference Manual".

Looks like I have an old TRM with me, which has EOI register at 24h.
I need to update my TRM. ;)
> This document ends with 16.5 that means there is no chapter 16.6 or
> 16.7. The next one is 17.
> 16.5.2 and 16.5.3 describes the available registers of
> USB[01]_CTRL REGISTERS which is where the EOI register is accessed. I
> see here
>
>    20h USB0IRQMSTAT
>    28h USB0IRQSTATRAW0
>
> so no 0x24 at least in my document.
>
> Sebastian


-- 
-George

