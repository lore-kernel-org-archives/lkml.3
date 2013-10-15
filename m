Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3JOGhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:37:16 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63142 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3JOGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:37:14 -0400
MIME-Version: 1.0
In-Reply-To: <1381818878-19469-1-git-send-email-geert@linux-m68k.org>
References: <1381818878-19469-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 15 Oct 2013 08:37:12 +0200
X-Google-Sender-Auth: SObvJkLALX7cweiESyMQu9nZ2C0
Message-ID: <CAMuHMdVe2YOhR56oFxJ_FF3XmdbqP19D6qu=cabv7dZzBKqK6w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.12-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 8:34 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.12-rc5 to v3.12-rc4[3], the summaries are:
>   - build errors: +13/-6

  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error:
'KEXEC_CORE_NOTE_NAME' undeclared (first use in this function):  =>
521:36
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error:
'crashing_cpu' undeclared (first use in this function):  => 408:2
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error:
'note_buf_t' undeclared (first use in this function):  => 624:49
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error:
'vmcoreinfo_max_size' undeclared (first use in this function):  =>
874:18
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error: implicit
declaration of function 'crash_save_vmcoreinfo'
[-Werror=implicit-function-declaration]:  => 410:2
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error: implicit
declaration of function 'elf_core_copy_kernel_regs'
[-Werror=implicit-function-declaration]:  => 520:2
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error: implicit
declaration of function 'paddr_vmcoreinfo_note'
[-Werror=implicit-function-declaration]:  => 872:2
  + /scratch/kisskb/src/arch/powerpc/kernel/fadump.c: error: storage
size of 'prstatus' isn't known:  => 513:22

powerpc-randconfig

  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error:
'DMTE6_IRQ' undeclared (first use in this function):  => 58:21
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error:
implicit declaration of function 'dma_alloc_writecombine'
[-Werror=implicit-function-declaration]:  => 91:2
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error:
implicit declaration of function 'dma_free_writecombine'
[-Werror=implicit-function-declaration]:  => 176:3

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6776/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6753/ (all 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
