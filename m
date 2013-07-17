Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3GQK6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:58:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44389 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab3GQK6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:58:10 -0400
Message-ID: <1374058684.2103.7.camel@dabdike>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Date: Wed, 17 Jul 2013 12:58:04 +0200
In-Reply-To: <51E660C6.1020409@oracle.com>
References: <20130715204135.GH15531@xanatos>
	 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	 <1373926109.17876.221.camel@gandalf.local.home>
	 <20130715223615.GI15531@xanatos>
	 <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
	 <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com>
	 <20130716211235.GG4994@xanatos> <20130716212704.GB9371@thunk.org>
	 <20130716224357.GK4994@xanatos>
	 <1374015299.6458.76.camel@gandalf.local.home>
	 <20130716231217.GL4994@xanatos> <51E5E609.1030202@oracle.com>
	 <1374022296.6458.118.camel@gandalf.local.home>
	 <51E660C6.1020409@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 17:15 +0800, Jeff Liu wrote:
> On 07/17/2013 08:51 AM, Steven Rostedt wrote:
> 
> > On Wed, 2013-07-17 at 08:32 +0800, Jeff Liu wrote:
> > 
> >> Another thing might deviated from the main theme, but I'd like to raise it
> >> here because I would like to see what's the proper way for that.
> >>
> >> For instance, people A posted a patch set to the mailing list at first,
> >> people B think that there are some issues in A's implementation, and he
> >> happened to play around the same stuff recently, so he submitted another
> >> patch series.  Finally, people B made it.
> >> (In that period, people A kept silent, maybe because he/she was unhappy) 
> >>
> >> This is a actual occurrence I once observed from a subsystem list(my
> >> apologies, I just want to talk this case rather than against somebody),
> >> it seems people A is a new comer(because I can not searched any past
> >> commits of him/her from the git log), people B is definitely a senior guy.
> >>
> >> So that's my question, is that a proper collaboration form in kernel
> >> community?  Does it better if people B could give some suggestions to
> >> help A to improve the code, especially if those help would help A stepping
> >> into the kernel development -- maybe it's depend largely on one's opinion. :(
> > 
> > This is a completely different issue from the one in this thread, but it
> > is also a legitimate issue and honestly, a bigger one than perceived
> > insults.
> > 
> > Is it proper collaboration? Absolutely not. Something that I try to be
> > sensitive to as it's something I can do as well. There's been things on
> > my todo list, where someone would send me patches that do it. I would be
> > thinking "darn it, I wanted to do it" and even worse, the patches that
> > were sent wouldn't be of the way I wanted them. But I've tried to be
> > good, and instead of just going about and implementing it myself, I
> > would try to help the person massage the patches into what I wanted.
> 
> It's kind of you. Generally, most forks are nice enough in helping others.
> Actually, I only noticed once of something like that the year before.
> Well, I just received an offline email from my college a fews hours ago as
> she checked this topic and unfortunately, she has experienced the same thing
> a few days ago.

If you want a quiet investigation, I or one of the other maintainers can
do it offline (you'll need to send the details via private email). Just
for your information, though, I've done this sort of thing before too.
This is probably the most egregious example:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2908d778ab3e244900c310974e1fc1c69066e450

James


