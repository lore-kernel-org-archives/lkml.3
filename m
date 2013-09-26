Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3IZIW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:22:58 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35809 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3IZIWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVc6N3ThirpsOFOtJ-9EUN77R38TyAyVPMMgH_y1+NOCQ@mail.gmail.com>
References: <1378532588-6054-1-git-send-email-michael.opdenacker@free-electrons.com>
	<CAMuHMdVc6N3ThirpsOFOtJ-9EUN77R38TyAyVPMMgH_y1+NOCQ@mail.gmail.com>
Date: Thu, 26 Sep 2013 10:22:53 +0200
X-Google-Sender-Auth: IT0m1pIJe7v8rGMv3BjEi-wxgt0
Message-ID: <CAMuHMdVEAZy5_rrLYyc2FWe1n1WjpKKOczTaPs4XLjKMto5pwQ@mail.gmail.com>
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

On Mon, Sep 9, 2013 at 9:32 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, Sep 7, 2013 at 7:43 AM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> This patch proposes to remove the IRQF_DISABLED flag from m68k architecture
>> code. It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>
> Thanks!
>
> BTW, 2 years ago Yong Zhang sent 3 big versions of series removing
> IRQF_DISABLED everywhere.
> At that time, I had hoped they would all go in through tglx:
>
> | > But do you expect the individual
> | > maintainers to take these patches, or are you just collecting Acks?
> |
> | Quoted from Thomas's reply to Ralf (MIPS):
> | [ We can hold off the "remove the define" patch until 3.2-rc1 and push
> | it along with everything which hasn't been merged until then.
>
> but apparently that never happened... oh well...
>
> Anyway, will queue if nothing happens at the global front...

Queued for 3.13.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
