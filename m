Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaCRIul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:50:41 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61256 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaCRIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <1395132465-19450-1-git-send-email-geert@linux-m68k.org>
References: <1395132465-19450-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 18 Mar 2014 09:50:37 +0100
X-Google-Sender-Auth: qj6uU7KBEjFW44IrzpPK4SAWpR0
Message-ID: <CAMuHMdVUKbgKEaQ-0ksTd3NJoNASmqy0CiVH6AryAt-HT7Qy3A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux I2C <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 9:47 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14-rc7[1]  to v3.14-rc6[3], the summaries are:
>   - build errors: +5/-13

Ignoring randconfig failures that are not really new:

  + /scratch/kisskb/src/drivers/i2c/busses/i2c-cpm.c: error: implicit
declaration of function 'irq_of_parse_and_map'
[-Werror=implicit-function-declaration]:  => 449:2
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-cpm.c: error: implicit
declaration of function 'of_iomap'
[-Werror=implicit-function-declaration]:  => 460:2

powerpc/mpc85xx_defconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7277/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7258/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
