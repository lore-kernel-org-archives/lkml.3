Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3GQTnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:43:52 -0400
Received: from 1wt.eu ([62.212.114.60]:34859 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab3GQTnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:43:51 -0400
Date: Wed, 17 Jul 2013 21:40:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, CAI Qian <caiqian@redhat.com>,
        David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Message-ID: <20130717194015.GP24293@1wt.eu>
References: <20130716212704.GB9371@thunk.org> <20130716224357.GK4994@xanatos> <1374015299.6458.76.camel@gandalf.local.home> <20130716231217.GL4994@xanatos> <51E5D7C8.5000306@gmail.com> <1374018809.2249.29.camel@leira.trondhjem.org> <1000066089.1803398.1374046596236.JavaMail.root@redhat.com> <20130717144849.GB16513@xanatos> <1374073771.6458.143.camel@gandalf.local.home> <20130717185138.GC17906@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717185138.GC17906@xanatos>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:51:38AM -0700, Sarah Sharp wrote:
> I assume you also want me to exclude the verbal abuse and personal
> threats I've received via email and my blog because of this thread.
> But, just for reference, I'll post them here as well.

[ comments removed not to give them too much publicity ]

(...)

Sadly now you see that your friends are here on LKML and that some
outsiders are much much worse. You'd probably prefer being criticized
by Linus for your design choices than having to ever work with one of
the stupid donkeys that wrote the excerpts you published.

(...)
> Speaking out about this has made the crazies come out of the woodwork.

It always happens on public discussions unfortunately. It's the only
way they find to feel like they exist. (BTW calling them crazies is
an attack to their person and may be contrary to what you'd like to
see on this ML, no ?).

> It means I now have to book a rental car so I don't have to be on public
> transit, and book a hotel room so I don't have to be home.  Those
> crazies, especially the local Portland SW developer, can easily find my
> home address from my blog domain name whois info.

There is no reason to fear the stupid who use public places to threaten.
It's their moment of glory. After that they go to the toilets and have a
5-to-1 session and they relax.

> Being a woman in open source, and speaking out, means I put my personal
> safety in jeopardy.  I should not have to put up with this.  We should
> be able to have a private conversation at KS without the court of public
> opinion getting involved.  However, that's not the way it went, and now
> I have to deal with the verbal abuse, sexist statements, and threats
> that are the backlash from this thread.

That's the risk of launching very sensitive subjects on mailing lists. I
don't know if you remembers the era of the trolls, we had almost once a
month 7-8 years ago, it was hard to get rid of them. They just started
non-tech subjects that always derived into flame wars. Here you started
a subject of real concern that merits being discussed about, but which
relates more to emotion and culture, and derives the same way.

> > Usually sensitive developers would listen the first time they are told.
> > It's more of the thick skin developers that push the envelope. But I
> > understand, its the "image" that bothers you.
> 
> No, it's actually some of the comments I've received that bother me.
> For example, I would never want to deal with the misogynist troll,
> Lubin, EVER again.
(...)

> Telling me my job at Intel is in jeopardy because I'm complaining about
> sexist statements is a threat.

I was about to comment on the fact that you're 3 from intel who'd better
use your private addresses to avoid the image of "intel vs Linus" that
some may get but since all your comments have been clean and argumented,
there is no reason for anyone sane to consider them inappropriate. Intel
would be foolish to fire you when you tried to raise the professional
look of the Linux community even if many (including me) disagree.

> It's verbal abuse, and I won't take it.
> I shouldn't have to put up with these kinds of statements and personal
> attacks.

Too late, it's done, you must have no regrets and stay firmly in your shoes
(and listen to sane people's arguments).

> I disagree that we should educate people that Linux really isn't that
> harsh.  We are technically harsh, and always will be.  Linux kernel
> developers require perfect code, and perfectly formatted patches.
> Setting up mentees to think otherwise is simply not advisable.

I disagree. Precisely what the newcomers need is to find their way through
the forest of maintainers, reviewers, etc... You can send patches in whatever
format, someone will always tell you how to fix this. You'll at least get one
nice person taking the time to explain to you. We all experienced this. What
needs to be taught to newcomers is how the process works, to ignore the few
irrespectful people who will immediately comment on their indentation with
harsh words and better wait for the more teaching comments that come later,
to take care of every such comments, ask when they don't understand, and
repost.

The questions I've got from newcomers were along "Have you ever got an
e-mail from Linus ? Wow... Have you ever met him ? No ? Strange, are there
many people who don't meet ?" etc... They're completely lost because for
them this project is almost sci-fi. I try to make them understand that my
contribution is very small and non-important and that I'm as dumb as they
are so there is no reason they can't participate. Once they can accept
that, most of the job is done. The remaining part is to ensure they're
not discouraged by the formalities about merge windows, subsystems, -rc,
etc.

> However,
> we can assure them that they won't see harsh _personal_ attacks, and
> coach them through dealing with their first harsh attacks against their
> _code_.

No I prefer to tell them that with I don't know how many thousands of
subscribers, they *will* get some personal attacks that they can simply
ignore just like when they cross a drunk man on the street shouting words
at bystanders.

Best regards,
Willy

