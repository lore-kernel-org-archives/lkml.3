Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaDVVXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:01 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51785 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaDVVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:22:47 -0400
Message-ID: <5356DDA0.6060405@gmail.com>
Date: Tue, 22 Apr 2014 23:22:40 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Rob Herring <robherring2@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: berlin: add CPU_V7 to Marvell Armada 1500-mini (BG2CD)
References: <1397587699-11023-1-git-send-email-sebastian.hesselbarth@gmail.com> <5356B0C2.6010708@gmail.com> <CAL_JsqKvBWk3bD3=G=kY+8yitV6M7Gx=7JnwJeH=yns5dvXbnA@mail.gmail.com>
In-Reply-To: <CAL_JsqKvBWk3bD3=G=kY+8yitV6M7Gx=7JnwJeH=yns5dvXbnA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 08:29 PM, Rob Herring wrote:
> On Tue, Apr 22, 2014 at 1:11 PM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>> On 04/15/2014 08:48 PM, Sebastian Hesselbarth wrote:
>>> This selects missing CPU_V7 for ARM Cortex-A9 based Marvell Armada
>>> 1500-mini (BG2CD).
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> ---
>>
>> Applied to berlin/soc.
>>
>>> ---
>>>  arch/arm/mach-berlin/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
>>> index d3c5f14dc142..0add8350faf4 100644
>>> --- a/arch/arm/mach-berlin/Kconfig
>>> +++ b/arch/arm/mach-berlin/Kconfig
>>> @@ -18,6 +18,7 @@ config MACH_BERLIN_BG2
>>>  config MACH_BERLIN_BG2CD
>>>       bool "Marvell Armada 1500-mini (BG2CD)"
>>>       select CACHE_L2X0
>>> +     select CPU_V7
> 
> This should not be needed. This gets selected by multi-platform with
> ARCH_MULTI_V7.

Dropped again, thanks for sending the cleanup :)

Sebastian

