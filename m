Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab3GQBXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:23:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:59351 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3GQBXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,680,1367996400"; 
   d="scan'208";a="371470762"
Date: Tue, 16 Jul 2013 18:23:17 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Message-ID: <20130717012317.GN4994@xanatos>
References: <20130715223615.GI15531@xanatos>
 <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
 <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com>
 <20130716211235.GG4994@xanatos>
 <20130716212704.GB9371@thunk.org>
 <20130716224357.GK4994@xanatos>
 <1374015299.6458.76.camel@gandalf.local.home>
 <20130716231217.GL4994@xanatos>
 <51E5E609.1030202@oracle.com>
 <1374022296.6458.118.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374022296.6458.118.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

/me hands Steve a box of wet-wipes. :)

There's a lot of controversy over whether a senior developer
re-implementing someone's patchset is bad behavior.  I've seen it argued
both ways.  "If I don't write code, I will just become a patch-pushing,
pencil-pushing maintainer."  Or "I don't want to bother working with
newbies, it's faster to just implement this myself."

I really think it's up to the maintainer whether they want to mentor
someone through a big submission, or do it themselves.  I usually lean
towards mentorship, but hey, not everyone has the time.

One thing that might make it easier for the original submitter is making
sure they get a Signed-off-by line in the patchset that the maintainer
submits.  At the very least, their line should be directly below the
maintainer's.  That way, they get credit for the idea, and possibly help
improve their statistics in the Signed-off-by count for that kernel
revision.

I suspect people would object if I suggested the original submitter
should be the first Signed-off-by line, but in some cases it may be
appropriate.  Sometimes I take someone's code, leave it mostly intact,
and fix the bugs or add a feature that we really need before the code
can land.  In that case, it makes sense to give the original submitter
credit before the maintainer.

Sarah Sharp
