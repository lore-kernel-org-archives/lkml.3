Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3GOTH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:07:59 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33124 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3GOTH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130715184642.GE15531@xanatos>
References: <20130715155202.GC29526@xanatos>
	<CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	<20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715184642.GE15531@xanatos>
Date: Mon, 15 Jul 2013 12:07:56 -0700
X-Google-Sender-Auth: skBD0WZhg044b0zSFgggOdX89D4
Message-ID: <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:46 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>
> Bullshit.  I've seen you be polite, and explain to clueless maintainers
> why there's no way you can revert their merge that caused regressions,
> and ask them to fit it without resorting to tearing them down
> emotionally:

Oh, I'll be polite when it's called for.

But when people who know better send me crap, I'll curse at them.

I suspect you'll notice me cursing *way* more at top developers than
random people on the list. I expect more from them, and conversely
I'll be a lot more upset when they do something that I really think
was not great.

For example, my latest cursing explosion was for the x86 maintainers,
and it comes from the fact that I *know* they know to do better. The
x86 tip pulls have generally been through way more testing than most
other pulls I get (not just compiling, but even booting randconfigs
etc). So when an x86 pull request comes in that clearly missed that
expected level of quality, I go to town.

Similarly, you will see fireworks if some long-term maintainer makes
excuses for breaking user space etc. That will make me go into
incoherent rages.

The "polite Linus" example that you point to? That was a maintainer
asking for direction for when things went wrong and *before* sending
me something dubious. Of course I'm polite then.

Sarah, I don't have Tourettes syndrome. You seem to think that my
cursing is uncontrolled and random. I argue that it has causes. Big
difference.

            Linus
