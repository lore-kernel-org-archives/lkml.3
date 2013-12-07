Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab3LGQOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:14:47 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51460 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3LGQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:14:45 -0500
MIME-Version: 1.0
In-Reply-To: <1386432168-26334-1-git-send-email-geert@linux-m68k.org>
References: <1386432168-26334-1-git-send-email-geert@linux-m68k.org>
Date: Sat, 7 Dec 2013 17:14:45 +0100
X-Google-Sender-Auth: VVKFbL8pB4Ca0I2dtNcImSwjexQ
Message-ID: <CAMuHMdW_sS2+8yrXRPyiToiWhRWn4PjLMNQid63So3ikwogJvg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.13-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 5:02 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.13-rc3[1]  to v3.13-rc2[3], the summaries are:
>   - build errors: +3/-4

  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error:
'cached_to_uncached' undeclared (first use in this function):  =>
99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit
declaration of function 'cpu_context'
[-Werror=implicit-function-declaration]:  => 192:2

sh-randconfig

  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6964/ (119 out of 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6939/ (119 out of 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
