Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab3ICHqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:46:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51955 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3ICHqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
	<1378161032.32763.341.camel@haakon3.risingtidesystems.com>
	<CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
Date: Tue, 3 Sep 2013 09:46:40 +0200
X-Google-Sender-Auth: 4HbmE3OIFBvwEesc5QeVXQN-1lg
Message-ID: <CAMuHMdVGqE=4wfzQvQc_BZZXBecH1HPNT4ExLZiqw_DzH1sbzQ@mail.gmail.com>
Subject: Re: Linux 3.11
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 12:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Is there a reason why these did not get PULLed..?
>
> Very simple: I have no such email in my mailbox. I see the "target
> updates for v3.11-rc1" email (and I pulled that), and there is nothing
> since.
>
> I don't even have that mail in my lkml archives, much less as a private email.
>
> I see neither youe "-v2 PULL request" nor the "One more late v3.11
> specific regression" one. In fact, I see no emails from you at all
> from Aug 31.
>
> It may be that gmail hates you for some reason...
>
> [ time passes ]
>
> Yup. It's in my spam-box, with gmail helpfully telling me:
>
>    Why is this message in Spam? We've found that lots of messages from
> linux-iscsi.org are spam.  Learn more
>
> so something is rotten in the state of linux-iscsi.org.

Funny, I did receive it without spam-label.

I do search for "label:linux-kernel in:spam" once in a while, to unspam some.
Perhaps I taught gmail Nicholas' emails are not spam for me ;-)

Note that a long time ago, I added special gmail filters to not mark emails from
some kernel-hacking Google employees as spam. Just marking them as not spam
over and over didn't help, as they were using non-google SMTP servers for
their outgoing email.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
