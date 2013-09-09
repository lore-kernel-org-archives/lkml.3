Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3IIHcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 03:32:14 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62354 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3IIHcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 03:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <1378532588-6054-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378532588-6054-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Mon, 9 Sep 2013 09:32:13 +0200
X-Google-Sender-Auth: EwXyqhqq01dOvMrkKja02Jc_jMw
Message-ID: <CAMuHMdVc6N3ThirpsOFOtJ-9EUN77R38TyAyVPMMgH_y1+NOCQ@mail.gmail.com>
Subject: Re: [PATCH] m68k: remove deprecated IRQF_DISABLED
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Sam Creasey <sammy@sammy.net>, Luis Alves <ljalvs@gmail.com>,
        Greg Ungerer <gerg@uclinux.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 7:43 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove the IRQF_DISABLED flag from m68k architecture
> code. It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Thanks!

BTW, 2 years ago Yong Zhang sent 3 big versions of series removing
IRQF_DISABLED everywhere.
At that time, I had hoped they would all go in through tglx:

| > But do you expect the individual
| > maintainers to take these patches, or are you just collecting Acks?
|
| Quoted from Thomas's reply to Ralf (MIPS):
| [ We can hold off the "remove the define" patch until 3.2-rc1 and push
| it along with everything which hasn't been merged until then.

but apparently that never happened... oh well...

Anyway, will queue if nothing happens at the global front...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
