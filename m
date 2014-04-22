Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaDVVYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:24:18 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59223 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaDVVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:24:11 -0400
Message-ID: <5356DDF6.4010308@gmail.com>
Date: Tue, 22 Apr 2014 23:24:06 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>
Subject: Re: [PATCH 1/2] ARM: berlin: add MACH_BERLIN_BG2Q symbol
References: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com> <532CB252.6010702@gmail.com>
In-Reply-To: <532CB252.6010702@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 10:42 PM, Sebastian Hesselbarth wrote:
> On 03/21/2014 08:39 PM, Alexandre Belloni wrote:
>> Now that we start supporting the Marvell Berlin BG2Q, add a symbol
>> allowing to
>> differentiate that SoC from the other SoCs of the Berlin family.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Applied to berlin/defconfig, Thanks!
> 
>> ---
>>   arch/arm/mach-berlin/Kconfig | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
>> index 7a02d222c378..0ff6f5877076 100644
>> --- a/arch/arm/mach-berlin/Kconfig
>> +++ b/arch/arm/mach-berlin/Kconfig
>> @@ -24,6 +24,13 @@ config MACH_BERLIN_BG2CD
>>       select CPU_V7
>>       select HAVE_ARM_TWD if SMP
>>
>> +config MACH_BERLIN_BG2Q
>> +    bool "Marvell Armada 1500 Pro (BG2-Q)"
>> +    select CACHE_L2X0
>> +    select CPU_V7
>> +    select HAVE_ARM_TWD if SMP
>> +    select HAVE_SMP

As Rob Herring pointed out, CPU_V7 is already selected by MULTI_V7.
Also, with no agreement on how to proceed with SMP, I also dropped
HAVE_SMP for now.

Sebastian


>>   endmenu
>>
>>   endif
>>
> 

