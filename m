Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3JTVdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:33:13 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59523 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3JTVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <1382304603-26395-1-git-send-email-geert@linux-m68k.org>
References: <1382304603-26395-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 20 Oct 2013 23:33:11 +0200
X-Google-Sender-Auth: Og5PC6P-Gg7IVgRxRnqA1VciN0Q
Message-ID: <CAMuHMdX+X+v6+QavzDdJM7rQv2-ztZAyoi0iUBzmzs1xC6taWg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.12-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Cris <linux-cris-kernel@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 11:30 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.12-rc6 to v3.12-rc5[3], the summaries are:
>   - build errors: +9/-13

  + /scratch/kisskb/src/drivers/i2c/busses/i2c-pca-platform.c: error:
implicit declaration of function 'ioread8'
[-Werror=implicit-function-declaration]cc1: some warnings being
treated as errors:  => 46:2

cris-allmodconfig/cris-allyesconfig

  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

x86_64-randconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6796/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6776/ (all 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
