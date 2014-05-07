Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaEGWtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:49:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53041 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEGWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:49:05 -0400
Message-ID: <536AB85D.6090807@infradead.org>
Date: Wed, 07 May 2014 15:49:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: Build regressions/improvements in v3.15-rc4 (uml)
References: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 05:04 AM, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.15-rc4[1] compared to v3.14[2].
> 
> 
> *** ERRORS ***
> 
> 11 regressions:
>   + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error: overflow in enumeration values  CC      drivers/hwmon/smsc47m192.o:  => 51:2
>   + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error: overflow in enumeration values  CC [M]  drivers/usb/gadget/f_rndis.o:  => 51:2
>   + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error: overflow in enumeration values:  => 51:2
>   + /scratch/kisskb/src/arch/powerpc/kernel/head_44x.S: Error: invalid operands (*ABS* and *UND* sections) for `|':  => 686, 603
>   + /scratch/kisskb/src/arch/powerpc/mm/tlb_nohash_low.S: Error: unsupported relocation against PPC47x_TLBE_SIZE:  => 113
>   + /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]:  => 179:4

>   + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: 'TMPFS_MAGIC' undeclared (first use in this function):  => 31
>   + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: (Each undeclared identifier is reported only once:  => 31
>   + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: for each function it appears in.):  => 31
>   + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: linux/magic.h: No such file or directory:  => 16:25

#include <uapi/linux/magic.h>
instead of <linux/magic.h>



>   + error: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A
> 


-- 
~Randy
