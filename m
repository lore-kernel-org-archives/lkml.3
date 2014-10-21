Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaJUMQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:16:22 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56573 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbaJUMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:16:21 -0400
Message-ID: <54464E8E.8050908@gmail.com>
Date: Tue, 21 Oct 2014 14:16:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Jisheng Zhang <jszhang@marvell.com>, linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: berlin: sort Kconfig options
References: <1411712097-700-1-git-send-email-jszhang@marvell.com> <542A9FD4.5090002@gmail.com>
In-Reply-To: <542A9FD4.5090002@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.2014 14:19, Sebastian Hesselbarth wrote:
> On 09/26/2014 08:14 AM, Jisheng Zhang wrote:
>> Keep options alphabetically sorted.
>>
>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
>
> Jisheng,
>
> nice to see you are now contributing directly to Berlin, too.
> Anyway, I understand that it is nice to have it sorted alphabetically
> but as long as there is no direct need or relation with any other
> changes, let's keep it that way.
>
> As soon as there are any other patches touching Kconfig, I'll request
> to squash it in. Is that okay for you?

As I missed the v3.18 merge window, I squashed this into Antoine's
patch adding reset controller Kconfigs.

Thanks!

>> ---
>>   arch/arm/mach-berlin/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
>> index 5803f77..84d34e0 100644
>> --- a/arch/arm/mach-berlin/Kconfig
>> +++ b/arch/arm/mach-berlin/Kconfig
>> @@ -3,9 +3,9 @@ menuconfig ARCH_BERLIN
>>       select ARCH_HAS_RESET_CONTROLLER
>>       select ARCH_REQUIRE_GPIOLIB
>>       select ARM_GIC
>> -    select GENERIC_IRQ_CHIP
>>       select DW_APB_ICTL
>>       select DW_APB_TIMER_OF
>> +    select GENERIC_IRQ_CHIP
>>       select PINCTRL
>>       select RESET_CONTROLLER
>>
>>

