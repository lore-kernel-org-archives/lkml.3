Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBKRfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:35:52 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37352 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBKRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <1392140035-31263-1-git-send-email-geert@linux-m68k.org>
References: <1392140035-31263-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 11 Feb 2014 18:35:49 +0100
X-Google-Sender-Auth: HoLd62CXxLFciF6tf5giLkWP4ig
Message-ID: <CAMuHMdWVx3CCgUo0eWNwmghBvwhmmJYjyC0a1XVebO+kfg3DMQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 6:33 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14-rc2[1]  to v3.14-rc1[3], the summaries are:
>   - build errors: +3/-2

  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error:
implicit declaration of function 'dma_alloc_writecombine'
[-Werror=implicit-function-declaration]:  => 91:2
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error:
implicit declaration of function 'dma_free_writecombine'
[-Werror=implicit-function-declaration]:  => 176:3

sh4/sh-randconfig

  + error: jump_label.c: undefined reference to
`arch_jump_label_transform':  => .text+0x85dbc)

sparc64/sparc-allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7167/ (119 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7145/ (119 out of 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
