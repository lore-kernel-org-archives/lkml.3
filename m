Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbbASM5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:57:24 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62381 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbASM5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:57:23 -0500
MIME-Version: 1.0
In-Reply-To: <1421671838-14572-1-git-send-email-geert@linux-m68k.org>
References: <1421671838-14572-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 19 Jan 2015 13:57:21 +0100
X-Google-Sender-Auth: lt5Hl_Jcn0vWwUGA1-cCO9Jl1O8
Message-ID: <CAMuHMdVXSsjCVyt=5zZ2Q0Y8rFo92DHKgQELhWW5qKtOiAE3Uw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.19-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 1:50 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.19-rc5[1] to v3.19-rc4[3], the summaries are:
>   - build errors: +11/-17

  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD'
undeclared (first use in this function):  => 378
  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: (Each
undeclared identifier is reported only once:  => 378
  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: for each
function it appears in.):  => 378

um-i386/um-defconfig (hmm, we've seen that one before in v3.19-rc1)

  + /tmp/ccYWgjxd.s: Error: .err encountered:  => 47, 100

arm-randconfig

  + error: initramfs.c: undefined reference to `__stack_chk_guard':
=> .init.text+0x3150)

i386/i386-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8329/ (255 out of 262 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8294/ (255 out of 262 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
