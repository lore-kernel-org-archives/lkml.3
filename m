Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3GPGON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:14:13 -0400
Received: from 1wt.eu ([62.212.114.60]:34697 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3GPGOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:14:11 -0400
Date: Tue, 16 Jul 2013 08:13:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: NeilBrown <neilb@suse.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130716061341.GD12242@1wt.eu>
References: <20130715155202.GC29526@xanatos> <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu> <20130716084036.41a9c498@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716084036.41a9c498@notabene.brown>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Tue, Jul 16, 2013 at 08:40:36AM +1000, NeilBrown wrote:
> On Mon, 15 Jul 2013 21:17:27 +0200 Willy Tarreau <w@1wt.eu> wrote:
> 
> > Communication works two ways.
> 
> I understand that to mean (at least) that for communication, every message
> must be both sent and received.  So when constructing a message, it is
> important to think about how others will understand it.

Yes, and I'd say that "others" here is "most of the readers". I've been
using that in some large companies, sometimes people do wrong things and
defend themselves of stupid choices by putting tens of people in copy to
try to cover their ass.

This is where I please myself. I only assemble nice words that everyone
understands to build sentences that several readers will interprete with
a varying degree of aggressivity. The aggressivity is at its top for the
target, but non-existent for the most external readers. You end up with
a person justifying him/herself in public about something apparently not
existing, till the point where someone high asks "what are you talking
about, care to elaborate?". You get impressive results this way, wrong
projects being aborted, budgets to fix others. Not a single bad word,
yet it is an extermely unpleasant experience for the target who feels
naked in public and hates me. Quite frankly these persons would prefer
a single hard e-mail from Linus than a week long of chess game like this.
So yes, everyone's understanding is important.

> On a public email list there are an awful lot of "others", and it is very
> likely that any possible misunderstanding will be experienced by someone.
> I think it best to minimise opportunities for misunderstanding.

Yes exactly, especially for non-native readers who don't always
understand some cultural jokes. There were a number of non-important
jokes I didn't catch in this thread and that are not important. However
generally when Linus gives someone his "appreciation" for a given work,
there is very little room for misinterpretation, which is fine. He once
severely scolded me on the sec list for insisting on proposing a fix for
an issue I misunderstood. I had all the colorful details to understand
the issue and to realize that I was lacking some skills in the specific
area subject of the issue.

> > Sure it can be hard for newcomers but I don't remember having read him
> > scold a newcomer. 
> 
> I think that is not relevant.  He is scolding people senior developers in
> front of newcomers.  That is not likely to encourage people to want to become
> senior developers.

I'm not that sure, because instead newcomers think "this guy is a bastard, I
don't want to work with him, I'll work with maintainers instead". And that's
what is expected. They start by focusing on a given subsystem, and as years
pass, they realize that the guy with the big mouth is not that naughty,
especially when he helps them design or fix their work.

> Anecdote:  My son (in highschool) is doing a psych assignment where he is
> asking people to complete a survey which, among other things, asks about
> people fear/anxiety response to various situations (it is a fairly standard
> instrument I think[1]).  Last few times he checked, the situation with the
> highest average score was "One person bullying another".  Really, it isn't
> nice to watch.

That's an interesting study which very likely matches reality, but here
it's a bit different. The group of people is not just two guys having
words together, imagine a room with hundreds or thousands of people and
two in the middle fighting. They'll just get ignored by newcomers who
will preferably sit down close to people who discuss calmly.

I have another anecdote. A few years ago, one very discrete and respectful
developer used to help me with backports of some security fixes. At some
point I asked him "wouldn't you prefer to be on the sec list, it would be
easier", and he replied "Linus will never accept, he once scolded me in
public", and I replied "quite the opposite then, that's good for you".
And when I asked, Linus said "yes of course I want him on the list, he
can certainly help us". So as you see, if some people are impressed first,
they can still be brought in front of the one they fear and realize that
they were thinking wrong.

It can seem counter-producting first (as Sarah thinks) but I think that
the competent people find their way in this simply because they're backed
up by other ones. That's how I think we get that number of skilled people
at the top of each subsystem.

And last, from some feedback I got, I would suspect that some top developers
prefer one e-mail from Linus once in a while to countless e-mails from end
users who repeatedly criticize their work when something does not work like
they expect for whatever reasons (including PEBKAC).

Best regards,
Willy

