Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3GQFwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:52:10 -0400
Received: from 1wt.eu ([62.212.114.60]:34789 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab3GQFwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:52:07 -0400
Date: Wed, 17 Jul 2013 07:51:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeff Liu <jeff.liu@oracle.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Message-ID: <20130717055139.GC21611@1wt.eu>
References: <20130715223615.GI15531@xanatos> <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz> <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com> <20130716211235.GG4994@xanatos> <20130716212704.GB9371@thunk.org> <20130716224357.GK4994@xanatos> <1374015299.6458.76.camel@gandalf.local.home> <20130716231217.GL4994@xanatos> <51E5E609.1030202@oracle.com> <1374022296.6458.118.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374022296.6458.118.camel@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 08:51:36PM -0400, Steven Rostedt wrote:
> On Wed, 2013-07-17 at 08:32 +0800, Jeff Liu wrote:
> 
> > Another thing might deviated from the main theme, but I'd like to raise it
> > here because I would like to see what's the proper way for that.
> > 
> > For instance, people A posted a patch set to the mailing list at first,
> > people B think that there are some issues in A's implementation, and he
> > happened to play around the same stuff recently, so he submitted another
> > patch series.  Finally, people B made it.
> > (In that period, people A kept silent, maybe because he/she was unhappy) 
> > 
> > This is a actual occurrence I once observed from a subsystem list(my
> > apologies, I just want to talk this case rather than against somebody),
> > it seems people A is a new comer(because I can not searched any past
> > commits of him/her from the git log), people B is definitely a senior guy.
> > 
> > So that's my question, is that a proper collaboration form in kernel
> > community?  Does it better if people B could give some suggestions to
> > help A to improve the code, especially if those help would help A stepping
> > into the kernel development -- maybe it's depend largely on one's opinion. :(
> 
> This is a completely different issue from the one in this thread, but it
> is also a legitimate issue and honestly, a bigger one than perceived
> insults.
> 
> Is it proper collaboration? Absolutely not. Something that I try to be
> sensitive to as it's something I can do as well. There's been things on
> my todo list, where someone would send me patches that do it. I would be
> thinking "darn it, I wanted to do it" and even worse, the patches that
> were sent wouldn't be of the way I wanted them. But I've tried to be
> good, and instead of just going about and implementing it myself, I
> would try to help the person massage the patches into what I wanted.
> That takes a lot of effort and discipline, and honestly, helping someone
> else do the work you wanted is much harder than just doing it yourself. 
> 
> Sometimes the maintainer just takes the easier route, and does the work
> themselves (because it's also more fun too). But that's really a slap in
> the face of the person that submitted the work in the first place. If
> anything hurts the community, it's this behavior. Not Linus giving
> someone an ass wipe.

I'm used to practice a workaround for this issue on another project. When
a newcomer sends me wrong code trying to address a real issue, I first
spend a little time helping him/her. If I see that the gap is too large
for him/her to adapt his/her work without too much help from me, then I
do the work myself, propose to him/her and once it's OK, and ask him/her
to submit the work with his/her name. That way they quickly gain trust
in themselves, more easily feel part of the community and get a clearer
idea of what is needed. Generally patches quality significantly improves
with this, in very short time, because they realize the gap is huge and
that they won't get this chance often.

My principle is to value the effort more than the result. If the first
author spent one week digging into the code to identify an issue and
came up with the wrong fix, and I can fix it in 5 minutes, he certainly
deserves all the merits for the work, not me.

I don't believe this is that much practiced on LKML. I know at least
one developer who does this, but he's probably the exception. I more
often see counter proposals just as if two authors were fighting to
get their patch merged.

Willy

