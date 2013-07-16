Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab3GPVsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:48:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45533 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455Ab3GPVsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:48:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Date: Tue, 16 Jul 2013 23:58:05 +0200
Message-ID: <4384290.4rZz7uttsZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFwcT3pRjKKB3c+QPVZ3tREVKJwszE5EMwJ_eQTjPkOzXQ@mail.gmail.com>
References: <20130715155202.GC29526@xanatos> <20130716210856.GF4994@xanatos> <CA+55aFwcT3pRjKKB3c+QPVZ3tREVKJwszE5EMwJ_eQTjPkOzXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 16, 2013 02:23:46 PM Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 2:08 PM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> >
> > I do, however, object when the verbal abuse shifts from being directed
> > at code to being directed at *people*.  For example, Linus chose to
> > curse at Mauro [2] and Rafael [3], rather than their code:
> 
> Umm. Because it was actually the person who was the problem?
> 
> Trust me, there's a really easy way for me to curse at people: if you
> are a maintainer, and you make excuses for your bugs rather than
> trying to fix them, I will curse at *YOU*.
> 
> Because then the problem really is you.
> 
> And in *both* of the examples you cite, that was exactly the issue. It
> wasn't that there was a bug - it was that the maintainer in question
> basically refused to fix a regression.
> 
> Sure, there was a code problem. But that wasn't the big issue. Code
> can be broken, and can be utter crap, but as long as it's fixed, who
> cares?
> 
> But when top-level maintainers start ignoring the #1 rule in the
> kernel ("We don't regress user space"), then it's not the broken code
> that annoys me any more.
> 
> See the difference?
> 
> And yes, people who don't get this are people who I will literally
> refuse to work with. In both of the cases you cite, things resolved
> themselves quickly (in fact, with Rafael it was at least partially
> just bad communication, and I haven't had that issue with him before).

Actually, I didn't feel like I was being attacked personally then.

In fact, I didn't say what I really wanted to say in that reply to the reporter
and that evidently confused you, which only made me think it was better to be
more careful about sending replies to regression reports when Linus is on the
CC list.  But it was kind of fun to watch you go ballistic by mistake. ;-)

And the problem itself was really confusing IIRC (that was a regression in a
piece of code that wasn't even executed as a result of a different bug and the
fix for that different bug caused the regression to show up).

So no, not really a good example of "Linus cursing at people" as far as I'm
concerned.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
