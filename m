Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaGNSpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:45:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:53563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaGNSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:45:36 -0400
Message-ID: <53C4254A.3040900@infradead.org>
Date: Mon, 14 Jul 2014 11:45:30 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Nicholas Krause <xerofoify@gmail.com>, ben-linux@fluff.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk, tomasz.figa@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-s3c64xx: Remove all defintions not related to regs-clocks
References: <1405361664-5210-1-git-send-email-xerofoify@gmail.com>	 <53C4201E.3020708@infradead.org> <1405363234.13661.12.camel@x220>
In-Reply-To: <1405363234.13661.12.camel@x220>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 11:40, Paul Bolle wrote:
> On Mon, 2014-07-14 at 11:23 -0700, Randy Dunlap wrote:
>> On 07/14/14 11:14, Nicholas Krause wrote:
>>> This patch addresses the fix me message in this file that states to
>>> remove all definitions not related to reg-clocks in this header
>>> file.
>>>
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>  arch/arm/mach-s3c64xx/include/mach/regs-clock.h | 22 +---------------------
>>>  1 file changed, 1 insertion(+), 21 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-s3c64xx/include/mach/regs-clock.h b/arch/arm/mach-s3c64xx/include/mach/regs-clock.h
>>> index 4f44aac..46e64cc 100644
>>> --- a/arch/arm/mach-s3c64xx/include/mach/regs-clock.h
>>> +++ b/arch/arm/mach-s3c64xx/include/mach/regs-clock.h
>>> @@ -15,24 +15,4 @@
>>>  #ifndef __PLAT_REGS_CLOCK_H
>>>  #define __PLAT_REGS_CLOCK_H __FILE__
>>>  
>>> -/*
>>> - * FIXME: Remove remaining definitions
>>> - */
>>> -
>>> -#define S3C_CLKREG(x)		(S3C_VA_SYS + (x))
>>> -
>>> -#define S3C_PCLK_GATE		S3C_CLKREG(0x34)
>>> -#define S3C6410_CLK_SRC2	S3C_CLKREG(0x10C)
>>> -#define S3C_MEM_SYS_CFG		S3C_CLKREG(0x120)
>>> -
>>> -/* PCLK GATE Registers */
>>> -#define S3C_CLKCON_PCLK_UART3		(1<<4)
>>> -#define S3C_CLKCON_PCLK_UART2		(1<<3)
>>> -#define S3C_CLKCON_PCLK_UART1		(1<<2)
>>> -#define S3C_CLKCON_PCLK_UART0		(1<<1)
>>> -
>>> -/* MEM_SYS_CFG */
>>> -#define MEM_SYS_CFG_INDEP_CF		0x4000
>>> -#define MEM_SYS_CFG_EBI_FIX_PRI_CFCON	0x30
>>> -
>>> -#endif /* _PLAT_REGS_CLOCK_H */
>>> +/#endif /* _PLAT_REGS_CLOCK_H */
>>
>> I don't know about the other changes, but that last line looks like an error.
>> Did you build anything that #includes this header file?
> 
> I just did
>     git grep -n S3C_CLKCON_PCLK_UART
> 
> It was just a guess. I did not cherry pick the defines that covers! The
> output of that command is, I think, pretty clear. 
> 
> Nicholas, I think you've been told already to stop doing what you're
> doing again here. I try not to use colorful language on the net, but
> you're really pushing me here.
> 
> Please go find something other to do than grepping the kernel tree for
> FIXMEs!

Yes.

FIXMEs are not a suggested starting point for kernel beginners.
If they were easy to fix, they would already be fixed or most likely
would never have been introduced.


-- 
~Randy
