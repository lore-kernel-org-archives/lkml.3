Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaBIVhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:37:10 -0500
Received: from mail.active-venture.com ([67.228.131.205]:60918 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaBIVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:37:09 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F7F505.5010301@roeck-us.net>
Date: Sun, 09 Feb 2014 13:37:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Richard Weinberger <richard@nod.at>
CC: Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
References: <1391971686-9517-1-git-send-email-richard@nod.at>  <1391971686-9517-17-git-send-email-richard@nod.at> <1391979588.25855.41.camel@x220>
In-Reply-To: <1391979588.25855.41.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 12:59 PM, Paul Bolle wrote:
> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
>> The symbol is an orphan, get rid of it.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   arch/score/Kconfig | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
>> index c75d06a..c7a7b65 100644
>> --- a/arch/score/Kconfig
>> +++ b/arch/score/Kconfig
>> @@ -23,19 +23,16 @@ config ARCH_SCORE7
>>   	bool "SCORE7 processor"
>>   	select SYS_SUPPORTS_32BIT_KERNEL
>>   	select CPU_SCORE7
>> -	select GENERIC_HAS_IOMAP
>>
>>   config MACH_SPCT6600
>>   	bool "SPCT6600 series based machines"
>>   	select SYS_SUPPORTS_32BIT_KERNEL
>>   	select CPU_SCORE7
>> -	select GENERIC_HAS_IOMAP
>>
>>   config SCORE_SIM
>>   	bool "Score simulator"
>>   	select SYS_SUPPORTS_32BIT_KERNEL
>>   	select CPU_SCORE7
>> -	select GENERIC_HAS_IOMAP
>>   endchoice
>>
>>   endmenu
>
> Actually, all these select statements can be dropped. I sent a patch to
> do that about a year ago (but the link to that patch on lkml.org seems
> empty: https://lkml.org/lkml/2013/3/6/167 ).
>
> Good luck in getting a reply from the score maintainers. I never got
> one.
>

You could (and maybe should) try again. They maintainers have been
a bit more responsive after I suggested to remove the architecture.

Guenter


