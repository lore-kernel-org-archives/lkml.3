Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3GQT3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:29:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab3GQT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:29:32 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=QIZFyTDxVIcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WKn5AdJQQDgA:10 a=1XWaLZrsAAAA:8 a=TSbVqHtbAAAA:8 a=ImQOBHYDEjmBzdi4-OoA:9 a=QEXdDO2ut3YA:10 a=TevBShhfQLnf-39K:21 a=xeMDFrZKCGo9dBQJ:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374089368.6458.191.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
From: Steven Rostedt <rostedt@goodmis.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: CAI Qian <caiqian@redhat.com>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 17 Jul 2013 15:29:28 -0400
In-Reply-To: <20130717185138.GC17906@xanatos>
References: <20130716211235.GG4994@xanatos>
	 <20130716212704.GB9371@thunk.org> <20130716224357.GK4994@xanatos>
	 <1374015299.6458.76.camel@gandalf.local.home>
	 <20130716231217.GL4994@xanatos> <51E5D7C8.5000306@gmail.com>
	 <1374018809.2249.29.camel@leira.trondhjem.org>
	 <1000066089.1803398.1374046596236.JavaMail.root@redhat.com>
	 <20130717144849.GB16513@xanatos>
	 <1374073771.6458.143.camel@gandalf.local.home>
	 <20130717185138.GC17906@xanatos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 11:51 -0700, Sarah Sharp wrote:

> > I have to ask. How much verbal abuse have you received in LKML? And I
> > don't mean in this thread.
> 
> I assume you also want me to exclude the verbal abuse and personal
> threats I've received via email and my blog because of this thread.
> But, just for reference, I'll post them here as well.

That's the nastiness of the Internet, a different topic than LKML
development. And I don't consider this thread really a LKML thread, as
it's about social behavior and nothing about the Linux kernel itself.

> 
> Here's a gem from a senior software developer at Nvidia:
> https://picasaweb.google.com/116960357493251979546/Trolls#5901298464591248626
> 
> And another email from a software developer in Portland, where I live:
> https://picasaweb.google.com/116960357493251979546/Trolls#5901288095984358098

Both are cowardly trolls that didn't post publicly.

> 
> On my blog, here's some choice comments, mostly asking me to quit kernel
> development, along with more than a few misogynist comments:
> 
> "You volunteered to help out on the Linux journey. He never volunteered
> to care for your feelings, nor did anyone else. It’s an opt-in community
> and you can always opt out at any time. Caveat emptor."
> 
> "You’re no one compared to Linus. Start being Alan Cox or Theodore T’so
> first to criticize him for his behaviour."
> 
> "Drama Queen"
> 
> "The LKML is not a place for easily offended girls to be. Get over
> yourself."
> 
> "shit, just what we need – a bitch running around crying about how hurt
> her feelings are."
> 
> "Oy vey you poor goyi…girl. You need to teach these sexist boys that
> being racist is wrong. Think of the wonderful things that womyn have
> done in the IT field. Clearly Linus is a rape apologist who fosters
> negative views of minorities."
> 
> "This is why women are viewed as pathetic jokes, especially in the tech
> world – because you’re weak and ineffectual, insufferable pansies who
> expect the world to cater and accommodate your thin skin and easily
> offended hyper-sensibilities. Grow the fuck up bitch. It’s real cute how
> you’ve tried to paint yourself as some gallant Joan of Arc, crusading
> against “muh bigotry” and “muh intolerance.” You’re a feminist joke, one
> in a very long line."

Again, this is the Internet social media, which is not an environment
for productivity, but a cesspool of filth. Off topic to what I asked.

> 
> 
> Speaking out about this has made the crazies come out of the woodwork.

And what did you expect? The Internet if filled with assholes.

> It means I now have to book a rental car so I don't have to be on public
> transit, and book a hotel room so I don't have to be home.  Those
> crazies, especially the local Portland SW developer, can easily find my
> home address from my blog domain name whois info.
> 
> Being a woman in open source, and speaking out, means I put my personal
> safety in jeopardy.  I should not have to put up with this.  We should
> be able to have a private conversation at KS without the court of public
> opinion getting involved.  However, that's not the way it went, and now
> I have to deal with the verbal abuse, sexist statements, and threats
> that are the backlash from this thread.

This is a real issue, but not one that LKML can solve, nor Linus being
nicer will have any affect on it. It is the social media and the trolls
that live within it. Women, in particular, that fight for social change,
bring out the worse of the Internet dung bugs and they cowardly will
attack you behind anonymous accounts or private email.

You came out swinging at Linus when he mentioned to Greg that he needs
to yell at people more. You did that on a public list. I was actually
very impressed by your bravery in doing so because I knew (and expected
that you knew too) that this will stir up the feces that exists under
the Internet shoe.
 
The Internet is a dangerous tool. Like I really think Linus quietly
regrets saying "SHUT THE FUCK UP", it was done publicly and you and
others have been using it against him. By attacking Linus publicly, will
bring out the low life that will attack you. Is that right? No, but it's
a reality that you know far too well.

But you didn't yell at Linus because you get trolls on your blog and
private emails. You yelled at him because you were upset at the way he
yells at others thinking that this will keep good people from joining
our community. This may be the case, but I asked you, do you get yelled
at by kernel developers for your work? And again, not about this thread,
because this thread is not technical and has nothing directly to do with
Linux.


> 
> > You pointed out a few examples of Linus, and it usually comes from
> > someone that should know better being told not to do something, and they
> > continue to do it, and then finally Linus blows up. Linus doesn't start
> > his cursing at the first email. It takes a few to show that you deserve
> > a blow up.
> > 
> > Usually sensitive developers would listen the first time they are told.
> > It's more of the thick skin developers that push the envelope. But I
> > understand, its the "image" that bothers you.
> 
> No, it's actually some of the comments I've received that bother me.
> For example, I would never want to deal with the misogynist troll,
> Lubin, EVER again.
> 
> http://permalink.gmane.org/gmane.linux.usb.general/42482
> 
> "You may be seen as a liability by Intel preaching "feminism" on a
> public forum.  From their point of view: will you play the gender card
> on them.  Here is what you did: Instead of realizing that I was being
> _very_ sympathetic to a more diverse Linux development environment by
> using the phrase "the old boys club", you pretended to take offense, not
> realizing you're in fact becoming a liability.  That's okay. Honest
> mistake."
> 
> Telling me my job at Intel is in jeopardy because I'm complaining about
> sexist statements is a threat.  It's verbal abuse, and I won't take it.
> I shouldn't have to put up with these kinds of statements and personal
> attacks.

He gave you his personal opinion. He gave you his opinion that your job
may be in jeopardy. Is he your manager? Does he work or represent Intel?
If not, ignore him. I don't see that as verbal abuse. Tell him "who are
you to decide my job?".

> 
> > The scariest thing about Linux kernel development is that because its so
> > successful, and the development is so open to the world (you are
> > programming on a stage in a world theater), that thin skin people may
> > not be comfortable in that environment. What we need are mentors, and
> > educate people that Linux really isn't that harsh, and that the new
> > developers actually do have talent, and shouldn't be afraid to post
> > their code.
> 
> We do need mentors.  Thank you for signing up to be one.
> 
> I disagree that we should educate people that Linux really isn't that
> harsh.  We are technically harsh, and always will be.  Linux kernel
> developers require perfect code, and perfectly formatted patches.

I agree.

> Setting up mentees to think otherwise is simply not advisable.  However,
> we can assure them that they won't see harsh _personal_ attacks, and
> coach them through dealing with their first harsh attacks against their
> _code_.

That's what I meant. Sorry it was misunderstood. Yeah, it may be harsh
in the fact that we expect high quality code to get into the kernel, but
I meant, the harshness isn't personal unless you try to make it that
way.

> 
> > The last thing I want to do is to lower the quality of the kernel just
> > to get a wider range of developers.
> 
> I agree.  We shouldn't lower our coding standards.  We should however,
> take a very close look at our personal communication styles, in order to
> ensure we aren't excluding a wide range of developers.

I've said it several times in this thread. I think the tone of LKML has
been getting more tame, and it's not your father's mailing list
anymore. ;-)

-- Steve


