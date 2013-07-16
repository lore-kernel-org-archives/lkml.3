Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab3GPXik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:38:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab3GPXii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:38:38 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=p1-IFUXKkGwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kbqBV6VKySQA:10 a=qI-sqkvjAAAA:8 a=jdcjVJ9ZgjoJV0Fa4scA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374017917.6458.103.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML (was: [
 00/19] 3.10.1-stable review)
From: Steven Rostedt <rostedt@goodmis.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Date: Tue, 16 Jul 2013 19:38:37 -0400
In-Reply-To: <20130716231217.GL4994@xanatos>
References: <20130715204135.GH15531@xanatos>
	 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	 <1373926109.17876.221.camel@gandalf.local.home>
	 <20130715223615.GI15531@xanatos>
	 <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
	 <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com>
	 <20130716211235.GG4994@xanatos> <20130716212704.GB9371@thunk.org>
	 <20130716224357.GK4994@xanatos>
	 <1374015299.6458.76.camel@gandalf.local.home>
	 <20130716231217.GL4994@xanatos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 16:12 -0700, Sarah Sharp wrote:

> > What problem exactly are we trying to solve here?
> 
> Personal attacks are not cool Steve.

I never said it was. But no matter what we do, people *will* be
offended. Can't help that.

>   Some people simply don't care if a
> verbal tirade is directed at them.  Others do not want anyone to attack
> them personally, but they're fine with people attacking their code.

If all you do is send code, then that's all that will happen. If you
start dictating policy, then it may be directed at you.

> 
> Bystanders that don't understand the kernel community structure are
> discouraged from contributing because they don't want to be verbally
> abused, and they really don't want to see either personal attacks or
> intense belittling, demeaning comments about code.

I wonder how true this is. I don't mean just any bystander, but people
that actually have code they could submit.

I'll admit that when I first started sending patches to LKML, I was
terrified. Not because I was afraid of being scolded, but because I was
afraid that what I sent wasn't good. It was a true judgment of my work.
I was prettified. Sure, I wouldn't have liked being insulted, but as
long as there was backing of why my work sucked I would be OK with it. I
actually had a rather good response to my work and I hung around.

But is there code existing out in the world that isn't in because people
are afraid of being insulted? Or afraid of their code being insulted? I
was the latter, and as we all seem to agree, the insulting of code is
what we want to keep.


> 
> In order to make our community better, we need to figure out where the
> baseline of "good" behavior is.

"community" has all sorts of behavior. The question is, is there really
a problem here? Sure some people don't like it, but they are still here.
Do you plan on leaving the Linux community if Linus doesn't change?

Now that would be a shame if you did, because you are a talented
developer. But I've never seen people insult you directly on LKML. I
don't know about private emails, but that's not the topic here.


>   We need to define what behavior we want
> from both maintainers and patch submitters.  E.g. "No regressions" and
> "don't break userspace"

Yes, those do need to be documented.


>  and "no personal attacks".

I actually disagree with this. What I would say this instead: "try to
keep it technical and focus on the code. If you are upset at someone,
think twice before hitting send. But if you really think this is the
only way to deal with the situation, then that's your call, and you get
to deal with the consequences."

I don't think changing peoples behavior is going to work. It wont. You
don't want to change who you are, others don't want to change who they
are. Deal with it. But what we can do is just try to educate people on
what policies are needed to be a maintainer and code submitter (there is
documentation already on some of this), and then point it to people. If
people continue to ignore those after being shown, then yes, personal
attacks are then in order.


>   That needs to be
> written down somewhere, and it isn't.  If it's documented somewhere,
> point me to the file in Documentation.  Hint: it's not there.

Well, SubmittingPatches is there, but we should have a MaintainerRules
or something.

> 
> That is the problem.

We can always use better documentation.

-- Steve


