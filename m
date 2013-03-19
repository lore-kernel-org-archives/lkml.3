Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab3CSUwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:52:53 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42298 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933936Ab3CSUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:52:52 -0400
Date: Tue, 19 Mar 2013 21:52:49 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.9-rc3
In-Reply-To: <alpine.DEB.2.00.1303192148530.18971@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1303192149210.18990@ayla.of.borg>
References: <alpine.DEB.2.00.1303192148530.18971@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.9-rc3 to v3.9-rc2[3], the summaries are:
>   - build errors: +10/-12

10 regressions:
  + arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'inhibit_secondary_onlining' [-Werror=implicit-function-declaration]:  => 1855:2
  + arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'uninhibit_secondary_onlining' [-Werror=implicit-function-declaration]:  => 1862:2

ppc64_defconfig+UP

  + error: "devm_request_threaded_irq" [drivers/dma/dw_dmac.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/i2c/busses/i2c-ocores.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/i2c/i2c-smbus.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/media/platform/sh_veu.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/spi/spi-altera.ko] undefined!:  => N/A
  + error: "mfd_add_devices" [drivers/mfd/lpc_sch.ko] undefined!:  => N/A
  + error: "mfd_remove_devices" [drivers/mfd/lpc_sch.ko] undefined!:  => N/A

s390-allmodconfig

  + error: "vgacon_remap_base" [drivers/video/vga16fb.ko] undefined!:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5993/ (118 out of 117 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/5972/ (all 117 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
