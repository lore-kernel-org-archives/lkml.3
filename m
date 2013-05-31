Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3EaUyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:54:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43481 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3EaUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:54:06 -0400
Message-ID: <51A90DE8.1010009@atmel.com>
Date: Fri, 31 May 2013 22:54:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>,
        Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <wim@iguana.be>,
        <linux@arm.linux.org.uk>, <plagnioj@jcrosoft.com>,
        <ludovic.desroches@atmel.com>, <linux-kernel@vger.kernel.org>,
        <jm.lin@atmel.com>
Subject: Re: [PATCH 0/2] ARM: dts: add watchdog device tree node in at91 dts
 files
References: <1369969744-3428-1-git-send-email-wenyou.yang@atmel.com> <1369969893-7992-1-git-send-email-wenyou.yang@atmel.com> <CACQ1gAjF=L+tVcJc3QMv7HEYcny2y-HcDLGJ5N7XbM=_vL+dFQ@mail.gmail.com>
In-Reply-To: <CACQ1gAjF=L+tVcJc3QMv7HEYcny2y-HcDLGJ5N7XbM=_vL+dFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/2013 11:39, Richard Genoud :
> 2013/5/31 Wenyou Yang <wenyou.yang@atmel.com>:
>> Hello,
>>
>> The patches is to add watchdog device tree node for at91 SoC and board dts files.
>>
>> Since the watchdog is disabled in the at91bootstrap with default configuration,
>> if you want to use the watchdog in the kernel, you must make sure the watchdog
>> doesn't be disabled in the at91bootstrap.
>>
>> It is tested on at91sam9g20ek, at91sam9263ek, at91sam9g25ek
>> using Documentation/watchdog/src/watchdog-simple.c.
>>
>> It is based on v3.10-rc3, tested on linux-watchdog git tree as well.
>>
>> Best Regards,
>> Wenyou Yang
>>
>> Wenyou Yang (2):
>>    ARM: dts: add the watchdog nodes for at91 SoC
>>    ARM: dts: add the watchdog nodes for at91 boards
>>
>>   arch/arm/boot/dts/at91sam9263ek.dts         |    4 ++++
>>   arch/arm/boot/dts/at91sam9g20ek_common.dtsi |    4 ++++
>>   arch/arm/boot/dts/at91sam9m10g45ek.dts      |    4 ++++
>>   arch/arm/boot/dts/at91sam9n12.dtsi          |    6 ++++++
>>   arch/arm/boot/dts/at91sam9n12ek.dts         |    4 ++++
>>   arch/arm/boot/dts/at91sam9x5.dtsi           |    6 ++++++
>>   arch/arm/boot/dts/at91sam9x5ek.dtsi         |    4 ++++
>>   7 files changed, 32 insertions(+)
>>
>> --
>> 1.7.9.5
>>
>
> Those patches haven been floating around from quite some time.
> Let's merge them !
>
> Tested on sam9g35, v3.10-rc2
>
> Tested-by: Richard Genoud <richard.genoud@gmail.com>

Both patches added to the at91-3.11-dt branch. Thanks!

Bye,
-- 
Nicolas Ferre
