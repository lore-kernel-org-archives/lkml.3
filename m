Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbaLHK16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:27:58 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:43452 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaLHK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:27:57 -0500
MIME-Version: 1.0
In-Reply-To: <1418034294-17584-1-git-send-email-geert@linux-m68k.org>
References: <1418034294-17584-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 8 Dec 2014 11:27:55 +0100
X-Google-Sender-Auth: hgtTm354Yrg6pJTwk1suX0P2CvA
Message-ID: <CAMuHMdWqusEzKN_s1Uk+Ak=BrRkoTv=qpK1FT94DH_Tno2j2jA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 11:24 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18[1]  to v3.18-rc7[3], the summaries are:
>   - build errors: +13/-11

(ignoring non-interesting things)

  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfd'
undeclared (first use in this function):  => 1874:29
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfs'
undeclared (first use in this function):  => 1872:29
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfd'
undeclared (first use in this function):  => 1928:30
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfs'
undeclared (first use in this function):  => 1926:30
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit
declaration of function 'do_fp_load'
[-Werror=implicit-function-declaration]:  => 1872:4
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit
declaration of function 'do_fp_store'
[-Werror=implicit-function-declaration]:  => 1926:4
  + /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: implicit
declaration of function 'dump_tlb_44x'
[-Werror=implicit-function-declaration]:  => 912:4

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8168/ (262 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8143/ (262 out of 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
