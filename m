Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3L0Mdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:33:38 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48175 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3L0Mdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
	<20131225230935.GB13593@amd.pavel.ucw.cz>
	<BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
	<20131226142607.GA15225@amd.pavel.ucw.cz>
	<BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
Date: Fri, 27 Dec 2013 13:33:36 +0100
X-Google-Sender-Auth: jfL8l3Su13hdt-il0CvG1na73EQ
Message-ID: <CAMuHMdWKa92mKsNtrj-eKdhz=CFf2LfoSmC6=p4-QyEX54LFUw@mail.gmail.com>
Subject: Re: [PATCH] Add the LED burst trigger
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Xue <lgxue@hotmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 1:31 AM, Joe Xue <lgxue@hotmail.com> wrote:
> echo "-.-. *"> patten
> -              a long on then a off
> .              a short on then a off
> space     a long off
> *             mean repeat the patten
> s             mean indicate the patten just one time then stop

Why both "*" and "s"? What happens if none of them is specified?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
