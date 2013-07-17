Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab3GQBDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:03:46 -0400
Received: from ozlabs.org ([203.10.76.45]:52804 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3GQBDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:03:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ 00/19] 3.10.1-stable review
In-Reply-To: <20130716210856.GF4994@xanatos>
References: <20130715155202.GC29526@xanatos> <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu> <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com> <8738rf14zl.fsf@rustcorp.com.au> <20130716210856.GF4994@xanatos>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 17 Jul 2013 10:32:44 +0930
Message-ID: <878v16yp57.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:
> On Tue, Jul 16, 2013 at 02:22:14PM +0930, Rusty Russell wrote:
> Linus is complaining about code here, and the effects of merging bad
> code on his own tree.  I personally have no qualms with this type of
> harsh email, because it focuses on the code, not the person.
>
> I do, however, object when the verbal abuse shifts from being directed
> at code to being directed at *people*.  For example, Linus chose to
> curse at Mauro [2] and Rafael [3], rather than their code:
>
>
> "Mauro, SHUT THE FUCK UP!"

This one crosses the line.  There's no non-offensive way to tell a geek
"you are wrong", but this isn't even trying.  Bad Linus!

> "How long have you been a maintainer? And you *still* haven't learnt the
> first rule of kernel maintenance?"
>
> "Shut up, Mauro. And I don't _ever_ want to hear that kind of obvious
> garbage and idiocy from a kernel maintainer again. Seriously."
>
> "The fact that you then try to make *excuses* for breaking user space,
> and blaming some external program that *used* to work, is just
> shameful. It's not how we work."
>
> "Fix your f*cking "compliance tool", because it is obviously broken.
> And fix your approach to kernel programming."
...
> ...and I'm surprised to
> hear that kind of utter garbage from you in particular."

Linus repeats 5 times: you can tell he's upset.

> "Seriously. Why do I even have to mention this? Why do I have to
> explain this to somebody pretty much *every* f*cking merge window?"

This one is OK, actually.

So, I tried to rewrite Linus' email.  And it lost the raw, red-hot anger
of the original.  It no longer makes everyone listen.  It tempts one to
argue.

It is not as effective :(

But suggesting alternate expressions might be constructive.
Rusty.
