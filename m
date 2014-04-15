Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaDONxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:53:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49418 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDONxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:53:17 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <534D39C9.4090604@roeck-us.net>
Date: Tue, 15 Apr 2014 06:53:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.15-rc1
References: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 04:36 AM, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.15-rc1[1] compared to v3.14[2].
>
> Summarized:
>    - build errors: +30/-3
>    - build warnings: +106/-98
>
> As I haven't mastered kup yet, there's no verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.15-rc1.summary.gz
>
> Happy fixing! ;-)
>
> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/head/7375/ (all 119 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)
>
>
> *** ERRORS ***
>
> 30 regressions:
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_ANDCOND' undeclared (first use in this function):  => 178:17, 100:16
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_AVPN' undeclared (first use in this function):  => 213:16, 99:16, 177:17
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_BULK_REMOVE' undeclared (first use in this function):  => 268:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_CEDE' undeclared (first use in this function):  => 272:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_CPPR' undeclared (first use in this function):  => 279:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_ENTER' undeclared (first use in this function):  => 262:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_EOI' undeclared (first use in this function):  => 280:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_EXACT' undeclared (first use in this function):  => 56:6
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_IPI' undeclared (first use in this function):  => 281:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_IPOLL' undeclared (first use in this function):  => 282:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_NOT_FOUND' undeclared (first use in this function):  => 211:8, 97:8
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PARAMETER' undeclared (first use in this function):  => 155:10
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PROTECT' undeclared (first use in this function):  => 266:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PTEG_FULL' undeclared (first use in this function):  => 55:8
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PUT_TCE' undeclared (first use in this function):  => 270:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_REMOVE' undeclared (first use in this function):  => 264:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_RTAS' undeclared (first use in this function):  => 287:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_SUCCESS' undeclared (first use in this function):  => 108:8, 229:8, 141:12, 75:8
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_TOO_HARD' undeclared (first use in this function):  => 246:12
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_XIRR' undeclared (first use in this function):  => 278:7
>    + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_XIRR_X' undeclared (first use in this function):  => 283:7
>    + /scratch/kisskb/src/drivers/cpufreq/powernv-cpufreq.c: error: implicit declaration of function 'cpu_sibling_mask' [-Werror=implicit-function-declaration]:  => 241:2
>    + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 1102:4
>    + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 1130:3
>    + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 1097:4
>    + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]:  => 169:3
>    + /scratch/kisskb/src/include/linux/kvm_host.h: error: array subscript is above array bounds [-Werror=array-bounds]:  => 436:19
>    + error: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A
>    + error: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A
>    + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
>
Also:

arc:defconfig, arc:tb10x_defconfig, hexagon:defconfig:

include/linux/rculist.h:54: error: implicit declaration of function 'smp_store_release'

Guenter

