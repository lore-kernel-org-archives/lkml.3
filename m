Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaDAIB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:01:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62267 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDAIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <1396339078-22125-1-git-send-email-geert@linux-m68k.org>
References: <1396339078-22125-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 1 Apr 2014 10:01:26 +0200
X-Google-Sender-Auth: DO4NgKZeqcYRNar7tPm9L7QFSLU
Message-ID: <CAMuHMdX3TwTCL3A=g15qATx_zMBr+P12mR1Cg+qTnbfuQohi8g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 9:57 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14[1]  to v3.14-rc8[3], the summaries are:
>   - build errors: +2/-10

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

  + error: initramfs.c: undefined reference to `__stack_chk_guard':
=> .init.text+0x1067)

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7303/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torval
