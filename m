Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaALRQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:16:19 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:49577 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALRQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:16:17 -0500
Date: Sun, 12 Jan 2014 18:16:09 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Mark Jackson <mpfj@mimc.co.uk>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] arch/avr32/boards/mimc200/fram.c: add missing 'module.h'
 for MODULE_LICENSE
Message-ID: <20140112171609.GA3773@samfundet.no>
References: <1389341774-6589-1-git-send-email-slyfox@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389341774-6589-1-git-send-email-slyfox@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 10 Jan 2014 11:16:14 +0300 or thereabout, Sergei Trofimovich wrote:
> config: make ARCH=avr32 mimc200_defconfig
> 
>> All error/warnings:
>>
>>    arch/avr32/boards/mimc200/fram.c:79: error: expected declaration specifiers or '...' before string constant
>>    arch/avr32/boards/mimc200/fram.c:79: warning: data definition has no type or storage class
>>    arch/avr32/boards/mimc200/fram.c:79: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
>> >> arch/avr32/boards/mimc200/fram.c:79: error: function declaration isn't a prototype
> 
> Untested.

Looks very sane.

> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> CC: Mark Jackson <mpfj@mimc.co.uk>
> CC: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/boards/mimc200/fram.c | 1 +
>  1 file changed, 1 insertion(+)

I will append this to the AVR32 tree at git.kernel.org.

> diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
> index 9764a1a..76cb51d 100644
> --- a/arch/avr32/boards/mimc200/fram.c
> +++ b/arch/avr32/boards/mimc200/fram.c
> @@ -13,6 +13,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/proc_fs.h>
>  #include <linux/mm.h>
> +#include <linux/module.h>
>  #include <linux/io.h>
>  
>  #define FRAM_BASE	0xac000000
-- 
mvh
Hans-Christian Egtvedt
