Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3FKNhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:37:50 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49582 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3FKNhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1305122245510.5463@ayla.of.borg>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
 <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg> <alpine.DEB.2.00.1305122245510.5463@ayla.of.borg>
From: Markos Chandras <markos.chandras@gmail.com>
Date: Tue, 11 Jun 2013 14:37:07 +0100
Message-ID: <CAG2jQ8gLOGM4YkPi_utj6+2SkXRyQj8cwUTfaJiZMjqEMPHenA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (mips)
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "Linux/MIPS Development" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 May 2013 21:46, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
>> However, the full list of errors isn't that unmanageable, so I'm following
>> up with a digested list...
>
> arch/mips/kernel/crash_dump.c:67:17: error: assignment makes pointer from integer without a cast [-Werror]: 1 errors in 1 logs
> arch/mips/kernel/crash_dump.c:67:2: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
>         v3.10-rc1/mips/mips-allmodconfig
>
>
> drivers/net/ethernet/3com/3c59x.c:1026:2: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
> drivers/net/ethernet/3com/3c59x.c:1038:3: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 1 errors in 1 logs
>         v3.10-rc1/mips/mips-allmodconfig
>
>
> sound/oss/soundcard.c:69:31: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function): 1 errors in 1 logs
>         v3.10-rc1/mips/mips-allmodconfig
>
> Gr{oetje,eeting}s,
>
>                                                 Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                                             -- Linus Torvalds
>

Hi Geert,

My understanding is that this driver shouldn't depend on (PCI || EISA)
but rather on PCI because the PCI support in that driver do not
seem to be optional.

--
Regards,
Markos Chandras
