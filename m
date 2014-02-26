Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaBZJyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:54:21 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59524 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaBZJyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <1393408336-1367-1-git-send-email-geert@linux-m68k.org>
References: <1393408336-1367-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 26 Feb 2014 10:54:17 +0100
X-Google-Sender-Auth: MGD-2xwhtVwpnld4Ssxw4EHlDPU
Message-ID: <CAMuHMdVXF2LgyCnf8eGoVQ5LpWe4r06tA+fvjmakvrBqX9hzwg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:52 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14-rc4[1]  to v3.14-rc3[3], the summaries are:
>   - build errors: +3/-15

  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error:
'cached_to_uncached' undeclared (first use in this function):  =>
99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit
declaration of function 'cpu_context'
[-Werror=implicit-function-declaration]:  => 192:2

sh-randconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7212/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7190/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
