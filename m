Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3GQVv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:51:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41167 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab3GQVv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:51:26 -0400
Date: Wed, 17 Jul 2013 14:51:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML (was: [
 00/19] 3.10.1-stable review)
Message-ID: <20130717215119.GF4161@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <1373926109.17876.221.camel@gandalf.local.home>
 <CA+55aFwdYxfgE8B4oPVFXWTJUcnDKnM4cchZ=t08mFwEHX+TAA@mail.gmail.com>
 <1373999229.2148.87.camel@dabdike>
 <20130716211830.GX16780@linux.vnet.ibm.com>
 <1374041689.2036.14.camel@dabdike.svoaero.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374041689.2036.14.camel@dabdike.svoaero.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071721-7182-0000-0000-000007C20C5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 10:14:49AM +0400, James Bottomley wrote:
> On Tue, 2013-07-16 at 14:18 -0700, Paul E. McKenney wrote:
> > On Tue, Jul 16, 2013 at 10:27:09PM +0400, James Bottomley wrote:
> > > On Mon, 2013-07-15 at 15:38 -0700, Linus Torvalds wrote:
> > > > On Mon, Jul 15, 2013 at 3:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > >
> > > > > Can we please make this into a Kernel Summit discussion. I highly doubt
> > > > > we would solve anything, but it certainly would be a fun segment to
> > > > > watch :-)
> > > > 
> > > > I think we should, because I think it's the kind of thing we really
> > > > need at the KS - talking about "process".
> > > 
> > > Can you formulate the process issue to discuss?  I've heard "Linus needs
> > > to yell less at people" and "the mailing lists need to be more
> > > 'professional'" neither of which seems to identify an actual process.
> > > Are we perhaps discussing guidelines for giving feedback on patches?
> > > 
> > > > At the same time, I really don't know what the format would possibly
> > > > be like for it to really work as a reasonable discussion. And I think
> > > > that is important, because this kind of subject is *not* likely
> > > > possible in the traditional "people sit around tables and maybe
> > > > somebody has a few slides" format.
> > > 
> > > > A small panel discussion with a few people (fiveish?) that have very
> > > > different viewpoints, along with baskets of rotten fruit set out on
> > > > the tables? That could be fun. And I'm serious, although we might want
> > > > to limit the size of the fruit to smaller berries ;)
> > > 
> > > How about Lychees?  They're prickly on the outside, very wet on the
> > > inside and have large stones ...
> > 
> > They taste good, too.
> > 
> > > But what are the viewpoints?  "maintainers need to yell more"?
> > > "maintainers need to yell less"?  I don't think I agree with either.
> > > I'm perfectly happy to run linux-scsi along reasonable standards of
> > > civility and try to keep the debates technical, but that's far easier to
> > > do on a low traffic list; obviously, I realise that style of argument
> > > doesn't suit everyone, so it's not a standard of behaviour I'd like to
> > > see universally imposed.  In fact, I've got to say that I wouldn't like
> > > to see *any* behaviour standard imposed ... they're all basically cover
> > > for power plays (or soon get abused as power plays); the only real way
> > > to display leadership on behaviour standards is by example not by fiat.
> > 
> > OK, I am stupid enough to take a stab at this...
> > 
> > 1.	Does the Linux kernel community's health depend on the occasional
> > 	rant?  [My guess is that we simply have no way of knowing.
> > 	That said, I would be interested in hearing specific examples
> > 	of open-source communities that are as doing as well as is the
> > 	Linux community and that live within stricter social mores.
> > 	Cue arguments about exactly what "doing well" means...]
> > 
> > 2.	Could the Linux kernel community's health be improved by banning
> > 	the occasional rant?  [Again, I don't believe that we have any
> > 	way of knowing.]
> > 
> > 3.	Is there some reasonable way to accommodate a wide range of
> > 	styles of interaction within the Linux community?  [I hope that
> > 	the answer is "yes", but it probably becomes impossible if you
> > 	add the qualifier "that everyone is happy with".]
> > 
> > 4.	If there is some reasonable way to accommodate a wide range
> > 	of styles of interaction within the Linux community, can this
> > 	be done globally, or does this require that people who prefer a
> > 	specific style confine themselves to portions of the community
> > 	that practice that specific style?  [As I grow older, I become
> > 	increasingly pessimistic about the possibility of keeping everyone
> > 	happy, but who knows?]
> > 
> > For whatever it is worth...
> 
> Well, you have friends in acadaemia, perhaps there might be an
> interesting study here.  If you consider the management style of the
> kernel, does it enable contributions from a broader range of people than
> would be tolerated in industry?  Industry has a problem with what
> managers like to call "brilliant jerks" people who have a well
> recognised talent but who cannot be controlled (at least by the
> aforementioned managers) and become corrosive to the team (do we
> actually manage to make use of these people in the kernel?).  They also
> tend to have a problem at the bottom end: those who are just about OK at
> their jobs; certainly not bad enough to be fired but whom they'd dearly
> love to replace with better workers (does the attitude in the kernel
> tend to discourage these types?)
> 
> It's probably less relevant to the discussion at hand, but I'd be
> curious to see the results.  Assuming they say that we do have a higher
> output per developer, the next study could investigate why this is ...

I do like your problem statement better than mine, but I must add that
I have come across people who are much more "outspoken" in proprietary
projects than I have seen on LKML.  Sorry, no quotes via email, even
private email.  Face-to-face verbal only for that level of nastiness.

Most of my friends in academia are in computer science, but I have come
across a few business-school types.  Is this something that LF would be
interested in allowing me to place its name behind?

Also, such a study would require some interaction with the researchers,
should any be interested.  Would people be willing to be interviewed,
either by phone or email?  Or would such a study need to content itself
with analysis of email archives and online news sites?

							Thanx, Paul

