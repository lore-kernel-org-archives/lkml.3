Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab3GOXte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:49:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:46707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab3GOXtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:49:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,672,1367996400"; 
   d="scan'208";a="370762850"
Message-ID: <1373932170.28142.24.camel@envy.home>
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
From: Darren Hart <dvhart@linux.intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Date: Mon, 15 Jul 2013 16:49:30 -0700
In-Reply-To: <20130715223615.GI15531@xanatos>
References: <20130715174659.GC15531@xanatos>
	 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos>
	 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	 <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>
	 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	 <1373926109.17876.221.camel@gandalf.local.home>
	 <20130715223615.GI15531@xanatos>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 15:36 -0700, Sarah Sharp wrote:
> On Mon, Jul 15, 2013 at 06:08:29PM -0400, Steven Rostedt wrote:
> > On Mon, 2013-07-15 at 14:50 -0700, Linus Torvalds wrote:
> > > On Mon, Jul 15, 2013 at 1:41 PM, Sarah Sharp
> > > <sarah.a.sharp@linux.intel.com> wrote:
> > > >
> > > > Oh, FFS, I just called out on private email for "playing the victim
> > > > card".  I will repeat: this is not just about me, or other minorities.
> > > > I should not have to ask for professional behavior on the mailing lists.
> > > > Professional behavior should be the default.
> > > 
> > > Bullshit.
> > > 
> > 
> > Can we please make this into a Kernel Summit discussion. I highly doubt
> > we would solve anything, but it certainly would be a fun segment to
> > watch :-)
> 
> I agree, KS is where this conversation should be taking place.
> Attendees for this conversation (so far) should be Greg KH, Linus,
> Darren Hart, Steve Rostedt, Willy Tarreau, and me.
> 
> > > So as far as I'm concerned, the discussion is about "how to work
> > > together DESPITE people being different". Not about trying to make
> > > everybody please each other. Because I can pretty much guarantee that
> > > I'll continue cursing. To me, the discussion would be about how to
> > > work together despite these kinds of cultural differences, not about
> > > "how do we make everybody nice and sing songs sound the campfire"
> > > 
> > > Do you think you might be interested in *that* kind of discussion
> > > instead of the "you are abusing me" kind of discussion?
> > > 
> > > Because if you want me to "act professional", I can tell you that I'm
> > > not interested. I'm sitting in my home office wearign a bathrobe. The
> > > same way I'm not going to start wearing ties, I'm *also* not going to
> > > buy into the fake politeness, the lying, the office politics and
> > > backstabbing, the passive aggressiveness, and the buzzwords. Because
> > > THAT is what "acting professionally" results in: people resort to all
> > > kinds of really nasty things because they are forced to act out their
> > > normal urges in unnatural ways.
> 
> Yes, let's move this conversation into the "how to work together DESPITE
> people being different" realm.  I would be happy to have that
> discussion.  As Linus said, some people work together better than
> others.  Some people have different expectations of appropriate ways to
> interact with co-workers.  Sometimes that means that people only work
> with certain other co-workers, like Greg and I.
> 
> The people who want to work together in a civil manner should get
> together and create a "Kernel maintainer's code of conduct" that
> outlines what they expect from fellow kernel developers.  The people who
> want to continue acting "unprofessionally" should document what
> behaviors set off their cursing streaks, so that others can avoid that
> behavior.  Somewhere in the middle is the community behavior all
> developers can thrive in.
> 
> Some people won't agree with everything in that document.  The point is,
> they don't have to agree.  They can read the document, figure out what
> the community expects, and figure out whether they can modify their
> behavior to match.  If they are unwilling to change, they simply don't
> have to work with the developers who have signed it.
> 
> Perhaps a trusted third party could take a stab at a first draft of this
> document?  Greg KH?  Steve Rostedt?  Darren Hart?
> 

Well, I admit this wasn't the contribution I've been working toward for
my first KS invite, but if people think this would be valuable, I'm up
for helping out where I can. Now are we talking more about a code of
conduct or a process document. I'm more likely to help out on the
latter, as the former often raises my hackles a bit. I'm fine with a
few lines in the process document instructing people on the pitfalls of
written communication and to keep it civil, but I will not enumerate
the seven words you can't say on television as bad words that thou
shalt no use. Such a document would be largely ignored, and indeed, may
have the opposite of the desired result :-)

I do believe that someone from the intended audience of a document
should be the one to write the first draft (or they should be among the
reviewers if the authority drafts the document). For instance, I
believe I would be able to document how to work with -tip or -stable as
an individual contributor. I would not be a good candidate for writing
the "how to be a lieutenant to Linus" because I am neither Linus nor
one of his lieutenants. I concern myself with Thomas, Ingo, Peter Z.,
and Greg K-H, and increasingly David Miller, but I don't worry about
Linus because I trust these people to do that properly and I trust that
their rules are the ones I need to follow: if it's good enough for
them, it will make upstream eventually.

I will re-iterate one more time though, that personally, I am much more
interested in making it clear what sets people (OK, Linus) off in a
document like stable_kernel_rules where we can point violators to. A
document which eliminates the need to search LKML or -stable for
similar patches to determine the preferred process of the month. Where
possible, this would (IMO) be the default policy document and subsystem
maintainers would only deviate from it for very good reasons. For
example, having different comment formatting rules in checkpatch for
different subsystems strikes me as cruel and unusual. If someone goes on
a tirade for a violation that is not documented, the blame falls on them
IMHO. If it's documented, a newcomer gets a referral, a repeat offender
has opened themselves up to stronger forms of persuasion.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

