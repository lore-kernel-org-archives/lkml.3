Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaELHVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:21:51 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36904 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaELHVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140510124243.750ad9c92d4549f3a8f11eb5@skynet.be>
References: <20140510124243.750ad9c92d4549f3a8f11eb5@skynet.be>
Date: Mon, 12 May 2014 09:21:49 +0200
X-Google-Sender-Auth: -mqomz4rdG6BKnNkqkIslgvqLi0
Message-ID: <CAMuHMdXsOoasWi+sU3giux3erniaTS6M8e6cV2JgsTuMEYUPDA@mail.gmail.com>
Subject: Re: [PATCH 1/1 RESEND] arch/m68k/hp300/config.c: convert printk to pr_foo()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 12:42 PM, Fabian Frederick <fabf@skynet.be> wrote:
> This patch also fixes some checkpatch warnings
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
