Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3KXJRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:17:23 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34471 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3KXJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:17:18 -0500
MIME-Version: 1.0
In-Reply-To: <1385233105-20026-1-git-send-email-geert@linux-m68k.org>
References: <1385233105-20026-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 24 Nov 2013 10:17:18 +0100
X-Google-Sender-Auth: _K5yeq7ZXQn04a2pjbhw_Jk2-C0
Message-ID: <CAMuHMdVLg9uMh3FCHnE-=Dvd8XN283hvyybVid7ffmJpFNEYow@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.13-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 7:58 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> 8 regressions:
>   + /scratch/kisskb/src/arch/sparc/kernel/kgdb_64.c: error: implicit declaration of function 'exception_enter' [-Werror=implicit-function-declaration]:  => 162:7
>   + /scratch/kisskb/src/arch/sparc/kernel/kgdb_64.c: error: implicit declaration of function 'exception_exit' [-Werror=implicit-function-declaration]:  => 176:2

sparc64-allmodconfig

>   + /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian:  => 1:0
>   + /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian:  => 1:0
>   + /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian:  => 1:0
>   + <stdin>: error: -mcall-aixdesc must be big endian:  => 1:0

powerpc-allmodconfig
powerpc-allyesconfig

>   + error: drivers/built-in.o: undefined reference to `i2c_register_driver':  => .init.literal+0xd88)
>   + error: sram.c: undefined reference to `devm_regmap_init_i2c':  => .text+0x58ef8)

xtensa-allmodconfig
sparc-allmodconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
