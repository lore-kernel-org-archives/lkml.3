Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaEMSPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:15:32 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63640 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaEMSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140513174640.GA20961@infradead.org>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<20140513152429.GA15679@infradead.org>
	<alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de>
	<20140513174640.GA20961@infradead.org>
Date: Tue, 13 May 2014 20:15:24 +0200
X-Google-Sender-Auth: 84m-xu4oUpwiQ4kTkL9nPP7atBA
Message-ID: <CAMuHMdUqWO1HzU4mqx6RJCYSrxE2DKuxMeqYjDqQ_Xqm6=ktCg@mail.gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 7:46 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> and it
>> would be dumb as hell to have new archs use time_t 32bit when we are
>> currently twisting our brain around how to solve the y2038
>> problem. Simply because we can not do the BSD flag day approach and
>> change it.
>
> I don't think it's a good idea to have minor new architectures
> pointlessly different than the major ones.  Especially given that we'll
> absolutely have to fir the y2038 problem for 32-bit arm and probably
> x86 anyway.

Considering someone just told me he plans to keep on using PPC
based MVME boards for 8 more years, you can expect some of today's
32-bit hardware to be around in 24 years...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
