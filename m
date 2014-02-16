Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaBPU4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:56:22 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46628 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaBPU4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:56:13 -0500
MIME-Version: 1.0
In-Reply-To: <1392581854.28866.74.camel@x220>
References: <1392577203.28866.29.camel@x220>
	<1392577801.28866.35.camel@x220>
	<CAMuHMdVDjFmo4eQpbFVr_-T08c=kFSYUYjF=f2xfN+EXu4ZLsg@mail.gmail.com>
	<1392581854.28866.74.camel@x220>
Date: Sun, 16 Feb 2014 21:56:13 +0100
X-Google-Sender-Auth: KbTdBo0wqC9zRO-Ee2cHFysK3dc
Message-ID: <CAMuHMdXMiK-2VU8ze9ey4JhZKJqoU5LB+oOUwQ5LdhEmaDUFaw@mail.gmail.com>
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

On Sun, Feb 16, 2014 at 9:17 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2014-02-16 at 21:14 +0100, Geert Uytterhoeven wrote:
>> On Sun, Feb 16, 2014 at 8:10 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > Paul Mundt's address triggers a bounce. I received a bounce for a
>> > message I sent Paul last week too. Do other people have problems sending
>> > to lethal@linux-sh.org too?
>>
>> Yes, it sometimes fails.
>>
>> Anyway, AFAIK Paul is no longer taking sh-patches.
>
> If that's the case could someone please make MAINTAINERS reflect that
> situation?

Sent out an RFC.

> And, by the way, is there somebody that does take patches for sh?

Andrew Morton?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
