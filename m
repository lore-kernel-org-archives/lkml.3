Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab3JOUEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:04:00 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51773 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3JOUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <8761sy1gmb.fsf@xmission.com>
References: <1381859307-11932-1-git-send-email-geert@linux-m68k.org>
	<1381859307-11932-2-git-send-email-geert@linux-m68k.org>
	<8761sy1gmb.fsf@xmission.com>
Date: Tue, 15 Oct 2013 22:03:58 +0200
X-Google-Sender-Auth: GMjAKlYWOTc6aO2MFROfQ3BDQ9c
Message-ID: <CAMuHMdWfk5awf3ycuY0ULyzk-8gc209p0DGDXwYEM2si6KpCuw@mail.gmail.com>
Subject: Re: [PATCH 1/3] kexec: Add debug printing of kimage table entries
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-m68k <linux-m68k@vger.kernel.org>, kexec@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 9:25 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>> Print a list of pages to be copied if debugging is enabled.
>> Consecutive entries are merged to reduce screen clutter.
>
> Why is this desirable?
>
> I can understand this as debugging code to understand what is happening,
> but why would we want to maintain this print statement long term?

Because the next person who ports kexec to a new platform may need it,
so he doesn't have to reimplement the wheel?

It's disabled by default.

It also serves as documentation for the indirection page.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
