Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaDVS3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:29:15 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:47987 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaDVS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <5356B0C2.6010708@gmail.com>
References: <1397587699-11023-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<5356B0C2.6010708@gmail.com>
Date: Tue, 22 Apr 2014 13:29:11 -0500
Message-ID: <CAL_JsqKvBWk3bD3=G=kY+8yitV6M7Gx=7JnwJeH=yns5dvXbnA@mail.gmail.com>
Subject: Re: [PATCH] ARM: berlin: add CPU_V7 to Marvell Armada 1500-mini (BG2CD)
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:11 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 04/15/2014 08:48 PM, Sebastian Hesselbarth wrote:
>> This selects missing CPU_V7 for ARM Cortex-A9 based Marvell Armada
>> 1500-mini (BG2CD).
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>
> Applied to berlin/soc.
>
>> ---
>>  arch/arm/mach-berlin/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
>> index d3c5f14dc142..0add8350faf4 100644
>> --- a/arch/arm/mach-berlin/Kconfig
>> +++ b/arch/arm/mach-berlin/Kconfig
>> @@ -18,6 +18,7 @@ config MACH_BERLIN_BG2
>>  config MACH_BERLIN_BG2CD
>>       bool "Marvell Armada 1500-mini (BG2CD)"
>>       select CACHE_L2X0
>> +     select CPU_V7

This should not be needed. This gets selected by multi-platform with
ARCH_MULTI_V7.

Rob
