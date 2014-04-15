Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaDOLof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:44:35 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48105 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaDOLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
References: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 15 Apr 2014 13:44:30 +0200
X-Google-Sender-Auth: NSk1XDhfRi_r4cXuDNiz6IXYWA0
Message-ID: <CAMuHMdVTg2DAkvoSh=TkhFMs3WV-3FR0-VqfO6jd5c06aYTT6g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.15-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 1:36 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.15-rc1[1] compared to v3.14[2].
>
> Summarized:
>   - build errors: +30/-3

> 30 regressions:

  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_ANDCOND' undeclared (first use in this function):  => 178:17,
100:16
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_AVPN' undeclared (first use in this function):  => 213:16, 99:16,
177:17
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_BULK_REMOVE' undeclared (first use in this function):  => 268:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_CEDE' undeclared (first use in this function):  => 272:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_CPPR' undeclared (first use in this function):  => 279:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_ENTER' undeclared (first use in this function):  => 262:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_EOI' undeclared (first use in this function):  => 280:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_EXACT' undeclared (first use in this function):  => 56:6
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_IPI' undeclared (first use in this function):  => 281:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_IPOLL' undeclared (first use in this function):  => 282:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_NOT_FOUND' undeclared (first use in this function):  => 211:8, 97:8
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_PARAMETER' undeclared (first use in this function):  => 155:10
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_PROTECT' undeclared (first use in this function):  => 266:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_PTEG_FULL' undeclared (first use in this function):  => 55:8
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_PUT_TCE' undeclared (first use in this function):  => 270:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_REMOVE' undeclared (first use in this function):  => 264:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_RTAS' undeclared (first use in this function):  => 287:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_SUCCESS' undeclared (first use in this function):  => 108:8, 229:8,
141:12, 75:8
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_TOO_HARD' undeclared (first use in this function):  => 246:12
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_XIRR' undeclared (first use in this function):  => 278:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error:
'H_XIRR_X' undeclared (first use in this function):  => 283:7
  + /scratch/kisskb/src/include/linux/kvm_host.h: error: array
subscript is above array bounds [-Werror=array-bounds]:  => 436:19

powerpc-randconfig

  + /scratch/kisskb/src/drivers/cpufreq/powernv-cpufreq.c: error:
implicit declaration of function 'cpu_sibling_mask'
[-Werror=implicit-function-declaration]:  => 241:2

ppc64_defconfig

  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit
declaration of function 'gpio_direction_output'
[-Werror=implicit-function-declaration]:  => 1102:4
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit
declaration of function 'gpio_free'
[-Werror=implicit-function-declaration]:  => 1130:3
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit
declaration of function 'gpio_request'
[-Werror=implicit-function-declaration]:  => 1097:4
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit
declaration of function 'gpio_set_value'
[-Werror=implicit-function-declaration]:  => 169:3

BF537-STAMP_defconfig

  + error: "__invalidate_icache_range" [drivers/misc/lkdtm.ko]
undefined!:  => N/A

xtensa-allmodconfig (fix available, IIRC)

  + error: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A

mips-allmodconfig (fix available, IIRC)

  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

x86_64-randconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvald
