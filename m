Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaBPUOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:14:04 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60533 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaBPUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:14:02 -0500
MIME-Version: 1.0
In-Reply-To: <1392577801.28866.35.camel@x220>
References: <1392577203.28866.29.camel@x220>
	<1392577801.28866.35.camel@x220>
Date: Sun, 16 Feb 2014 21:14:01 +0100
X-Google-Sender-Auth: 6G8iMsh6XpbdaExLUl5Csw8XdkQ
Message-ID: <CAMuHMdVDjFmo4eQpbFVr_-T08c=kFSYUYjF=f2xfN+EXu4ZLsg@mail.gmail.com>
Subject: Re: [PATCH] sh: remove SH_ALPHA_BOARD
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 8:10 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2014-02-16 at 20:00 +0100, Paul Bolle wrote:
>> The Kconfig symbol SH_ALPHA_BOARD was added in v2.6.38. It has never
>> been used. Setting it has no effect. There are no calls for
>> mach_is_sh_alpha_board(). This symbol can safely be removed.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>
> Paul Mundt's address triggers a bounce. I received a bounce for a
> message I sent Paul last week too. Do other people have problems sending
> to lethal@linux-sh.org too?

Yes, it sometimes fails.

Anyway, AFAIK Paul is no longer taking sh-patches.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
