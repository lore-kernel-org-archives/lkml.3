Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaGKOKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:10:42 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56570 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaGKOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140711133705.401147885@linutronix.de>
References: <20140711133623.530368377@linutronix.de>
	<20140711133705.401147885@linutronix.de>
Date: Fri, 11 Jul 2014 16:10:38 +0200
X-Google-Sender-Auth: D_CEvOzzoeLApNhL0EmQBObDNqg
Message-ID: <CAMuHMdW=qaKDZX19_b=27b+L9jCa7FO3UkeJ_tkte0nM9sgy9A@mail.gmail.com>
Subject: Re: [patch 02/55] timekeeping: Simplify arch_gettimeoffset()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Jul 11, 2014 at 3:44 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Provide a default stub function instead of having the extra
> conditional. Cuts binary size on a m68k build by ~100 bytes.

Thanks about caring about binary size.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
