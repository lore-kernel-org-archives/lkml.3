Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3GLPWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:22:31 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35110 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab3GLPW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130712141530.GA3629@roeck-us.net>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130711222935.GA11340@redhat.com>
	<20130711224455.GA17222@kroah.com>
	<20130712141530.GA3629@roeck-us.net>
Date: Fri, 12 Jul 2013 08:22:27 -0700
X-Google-Sender-Auth: ngHDMDoB6o68j8m5_yqdsXOVtEk
Message-ID: <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 7:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> >
>> > I get the impression as soon as we hit -rc1, some maintainers immediately
>> > go into "OH SHIT, I CAN'T SEND PATCHES OR LINUS WILL SHOUT AT ME" mode.
>>
>> I agree.  But it seems that I need to now start shouting at them :(
>
> Just like others, I now have a cutoff-point for -stable patches. Depending on
> the severity of a bug, it is somewhere between -rc4 and -rc6. After -rc6 I only
> push regressions and crash fixes; the rest has to wait for the commit window.

So regressions, crash fixes (and security issues) is exactly what I
want to get after -rc3 or so. And yes, I will start shouting at people
if other things show up.

However, I think your comments clearly show the problem:

> So, yes, there are a couple of hwmon patches in your list.
>
> From a maintainer perspective, seems to me we are stuck between a rock and a
> hard place. Yes, I would prefer to push all -stable material even late in the
> -rc game, but that is not how things work nowadays anymore.

That's f*cking sad. You know *why* it's sad?

Go read the rules for stable patches. Really.

Because the rules for stable patches are the rules _I_ use for that
late -rc stuff, and is pretty much exactly what you yourself described
as "this is what I send Linus after -rc4".

Now, that should make you think about THE ABSOLUTE CRAP YOU MARK FOR -stable!

If it isn't important enough to send to me after -rc4, then it damn
well isn't important enough to mark for stable either!

It really is that simple.

> This should really be discussed at the Kernel Summit. Overall, I don't really
> care too much how to handle it. Just tell me. The outlook of "Either Linus
> will shout at you or Greg will" doesn't sound like a good solution, though.

Listen to yourself. In fact, there is a damn good solution": don't
mark crap for stable, and don't send crap to me after -rc4.

If it doesn't fit the stable rules, they should go in the next merge
window. It really is that simple. You even (unwittingly) pretty much
described the stable rules, but then you apparently didn't understand
that those were the rules for -stable too.

Of course, I suspect I see why this happens. Greg doesn't shout as
much as me, and he has been taking any random patches into -stable. So
the end result is that people think it's easier to mark things for
-stable than it is to show that it actualy *is* stable, and they are
trying to use -stable as a way to get any random late fixes in.

That is not how stable should work. When stable started, it had some
rather clear rules. It's not for "fixes". It was meant to be solely
for big issues.

The thing you just described that you put a stable tag on is *EXACTLY*
the things that should not be marked for stable. For *EXACTLY* the
same reason that you realized you shouldn't push it to me after -rc4.

Do you really not see this?

Greg, the reason you get a lot of stable patches seems to be that you
make it easy to act as a door-mat. Clearly at least some people say "I
know this patch isn't important enough to send to Linus, but I know
Greg will silently accept it after the fact, so I'll just wait and
mark it for stable".

You may need to learn to shout at people.

                   Linus
