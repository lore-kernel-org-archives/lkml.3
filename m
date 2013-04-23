Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3DWTgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:36:04 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:60735 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3DWTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:36:01 -0400
Date: Tue, 23 Apr 2013 21:35:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: x86@kernel.org, linux-cris-kernel@axis.com,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: Build regressions/improvements in v3.9-rc8
In-Reply-To: <alpine.DEB.2.00.1304232131300.11127@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1304232132050.11155@ayla.of.borg>
References: <alpine.DEB.2.00.1304232131300.11127@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.9-rc8 to v3.9-rc7[3], the summaries are:
>   - build errors: +9/-8

  + arch/x86/include/asm/uaccess_32.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct:  => 211:26

i386_defconfig, i386-randconfig

  + drivers/usb/gadget/fusb300_udc.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]  CC      fs/9p/xattr.o:  => 45:2

cris-allmodconfig, cris-allyesconfig

  + error: "vm_iomap_memory" [drivers/video/fb.ko] undefined!:  => N/A
  
bfin/BF537-STAMP_defconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6122/ (all 118 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6094/ (all 118 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
