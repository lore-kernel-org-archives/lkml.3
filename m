Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3GNUbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 16:31:08 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50654 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3GNUbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 16:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130714052441.GA9042@roeck-us.net>
References: <20130712173150.GA5534@roeck-us.net>
	<CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	<20130712195051.GB32054@1wt.eu>
	<20130713062223.GA15155@kroah.com>
	<20130713063607.GI32054@1wt.eu>
	<20130713064801.GA1305@kroah.com>
	<20130713114211.GA3112@thunk.org>
	<20130713182717.GA16637@kroah.com>
	<20130714022219.GC3112@thunk.org>
	<20130714035128.GA10697@kroah.com>
	<20130714052441.GA9042@roeck-us.net>
Date: Sun, 14 Jul 2013 22:31:04 +0200
X-Google-Sender-Auth: ifMt2NQnXR7uQQWIU1_b9DDAbQU
Message-ID: <CAMuHMdW5qpovGzt9YywTGsUW3vJZnZGdYr1QxWxu-MZOxky_Pg@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 7:24 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> You are confusing the words "real" and "critical" perhaps.  I, and other
>
> A typical classification of bugs might be
>         critical: mission critical, no workaround, must be fixed prior to
>                 customer release
>         severe (high): related to core functionality, must fix, but not
>                 necessarily in first release.
>         moderate (medium): Bugs that do not affect any critical user
>                 functionality; typically has workaround
>         minor (low): Bugs that do not interfere with core functionality
>                 and are just annoyances that may or may not ever be fixed
>         cosmetic: misspellings
>
> Such classifications are widely used in the industry. The term "affecting users"
> might apply to all of those, and even a cosmetic bug is "real".

And typically there's a distinction between severity (how bad is it), and
priority (how soon it should be fixed), wich are not always linearly correlated.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
