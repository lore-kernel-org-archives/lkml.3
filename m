Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaELHUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:20:50 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34192 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaELHUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140510123800.951b2f0883b148a91d0c5f8e@skynet.be>
References: <20140510123800.951b2f0883b148a91d0c5f8e@skynet.be>
Date: Mon, 12 May 2014 09:20:48 +0200
X-Google-Sender-Auth: Hcmj78nz_bFzgkNr_j9l48Aceec
Message-ID: <CAMuHMdVgOKuvu3W4oDRn71nwrY3DdQzLe5idPux4EFMNS7Syhg@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] ARCH/M68K/AMIGA: convert printk(foo to pr_foo()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 12:38 PM, Fabian Frederick <fabf@skynet.be> wrote:
> -no level printk converted to pr_warn/pr_info
> -fixed a small identation problem
>
> This is untested
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks, will queue for v3.16.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
