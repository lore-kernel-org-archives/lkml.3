Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096Ab3GPVXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:23:50 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:33067 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073Ab3GPVXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:23:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130716210856.GF4994@xanatos>
References: <20130715155202.GC29526@xanatos>
	<CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	<20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715184642.GE15531@xanatos>
	<20130715191727.GC10157@1wt.eu>
	<CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
	<8738rf14zl.fsf@rustcorp.com.au>
	<20130716210856.GF4994@xanatos>
Date: Tue, 16 Jul 2013 14:23:46 -0700
X-Google-Sender-Auth: zyWtinah-q1bRfzZihfzYCEmJY8
Message-ID: <CA+55aFwcT3pRjKKB3c+QPVZ3tREVKJwszE5EMwJ_eQTjPkOzXQ@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 2:08 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>
> I do, however, object when the verbal abuse shifts from being directed
> at code to being directed at *people*.  For example, Linus chose to
> curse at Mauro [2] and Rafael [3], rather than their code:

Umm. Because it was actually the person who was the problem?

Trust me, there's a really easy way for me to curse at people: if you
are a maintainer, and you make excuses for your bugs rather than
trying to fix them, I will curse at *YOU*.

Because then the problem really is you.

And in *both* of the examples you cite, that was exactly the issue. It
wasn't that there was a bug - it was that the maintainer in question
basically refused to fix a regression.

Sure, there was a code problem. But that wasn't the big issue. Code
can be broken, and can be utter crap, but as long as it's fixed, who
cares?

But when top-level maintainers start ignoring the #1 rule in the
kernel ("We don't regress user space"), then it's not the broken code
that annoys me any more.

See the difference?

And yes, people who don't get this are people who I will literally
refuse to work with. In both of the cases you cite, things resolved
themselves quickly (in fact, with Rafael it was at least partially
just bad communication, and I haven't had that issue with him before).
Other people, who seem to treat regressions cavalierly, I will first
make it *very* clear that it is unacceptable, and then I will refuse
to take their patches. It has happened.

And yes, if that's the reason some person doesn't like working with
the kernel ("Linus screams at me when I break things and don't want to
fix them"), then dammit, good f*cking riddance. I already saw exactly
that comment on G+ earlier today - somebody who is well-known for not
fixing his regressions ("fix your user instead") was talking about how
he doesn't want to work with me for that very reason.

So apparently my cursing works.

Seriously, Sarah, you need to get off this "you can't curse at
people". Because you *can* curse at people, and it very much is
sometimes called for.

               Linus
