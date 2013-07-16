Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099Ab3GPV1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:27:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab3GPV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:27:44 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=CdOr09jT1rAMFfpbRcIA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374010059.6458.74.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 16 Jul 2013 17:27:39 -0400
In-Reply-To: <20130716210856.GF4994@xanatos>
References: <20130715155202.GC29526@xanatos>
	 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	 <20130715174659.GC15531@xanatos>
	 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu>
	 <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
	 <8738rf14zl.fsf@rustcorp.com.au> <20130716210856.GF4994@xanatos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 14:08 -0700, Sarah Sharp wrote:

> 
> "Mauro, SHUT THE FUCK UP!"
> 
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
> 
> "Seriously. Why do I even have to mention this? Why do I have to
> explain this to somebody pretty much *every* f*cking merge window?"
> 
> "And btw, the *reason* for that rule becoming such a hard rule was
> pretty much exactly suspend/resume and ACPI. Exactly because we used
> to have those infinite "let's fix one thing and break another" dances.
> So you should be well acquainted with the rule, and I'm surprised to
> hear that kind of utter garbage from you in particular."

Reading all this again, it seems that Linus is pissed off at what Mauro
said, did or is doing. I don't really see a direct attack at Mauro as a
person. Not much different than being pissed off at someone asking Linus
to pull crap that's marked for stable. I see a very fine line between
the two.

Also, it seems that Linus is more disappointed with Mauro, as he expects
more from him.

Honestly, sometimes Linus needs to yell louder to top maintainers. As
its a way to wake us up that we need to be held to a higher regard.
Sometimes we may get complacent, and a bit lazy. If a top maintainer
starts to slack, major damage can be done. It needs to be serious.

I don't see the above as public shaming. It really just points out what
Linus expects from all maintainers, which would have been lost if this
were a private email.


> 
> 
> The personally directed verbal abuse is what I'm complaining about here.
> Linus goes from 0 to 11 at the drop of an "I don't think this is a
> regression" comment, and publicly ridicules his top maintainers.
> 
> This is not right.  This is not a community that people want to be a
> part of, except for a few top-tier maintainers who have "tough skins".
> No one should have to be the focus of a fire hose of personal verbal
> abuse.

I still don't see it as personal. Linus got pissed at what Mauro said
and did, not at Mauro as a person. Thus, not personal.

"I'm surprised to hear that kind of utter garbage from you in
particular"

I actually read the above as a complement.

> 
> We're adults, not high schoolers.  We can figure out how to deliver
> harsh technical criticism without resorting to name calling, cussing at
> people, or personal attacks.

Was there name calling in the above? I missed it.

> 
> If a maintainer is not doing their job, Linus should send them a private
> harsh email, and a public email that simply says, "I'm reverting this
> pull request because of X.  If this continues through the next merge
> window, this maintainer will need to train a replacement."  Don't
> publicly tear them to pieces because they made a simple mistake.

That kind of email will most likely be ignored by people. A harsh email
becomes popular and noticed by a larger audience.

> 
> 
> The definition of insanity is repeating the same thing, over and over,
> expecting the result to be different.  Linus keeps repeating the same
> mantras over and over to maintainers that forget rules like, "No
> regressions."

No, I think people have heard this. And sometimes we start to think:
well this one may be different. Seems that its the maintainers that try
to do the same thing over and over expecting a different result from
Linus which is what makes Linus insane.


> 
> Why aren't we trying different tactics?  Why aren't we improving our
> documentation so maintainers don't have to repeat themselves?

There's lots of documentation, and I think its more that maintainers
thinking "this time it's different" than anything else. I guarantee that
Mauro will not push userspace breakage again. And because of that email,
so will a lot of other maintainers.

-- Steve


