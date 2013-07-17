Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829Ab3GQAvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:51:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3GQAvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:51:39 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=QIZFyTDxVIcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WKn5AdJQQDgA:10 a=10rgkCLOpA4eSccT_JoA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374022296.6458.118.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 16 Jul 2013 20:51:36 -0400
In-Reply-To: <51E5E609.1030202@oracle.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 08:32 +0800, Jeff Liu wrote:

> Another thing might deviated from the main theme, but I'd like to raise it
> here because I would like to see what's the proper way for that.
> 
> For instance, people A posted a patch set to the mailing list at first,
> people B think that there are some issues in A's implementation, and he
> happened to play around the same stuff recently, so he submitted another
> patch series.  Finally, people B made it.
> (In that period, people A kept silent, maybe because he/she was unhappy) 
> 
> This is a actual occurrence I once observed from a subsystem list(my
> apologies, I just want to talk this case rather than against somebody),
> it seems people A is a new comer(because I can not searched any past
> commits of him/her from the git log), people B is definitely a senior guy.
> 
> So that's my question, is that a proper collaboration form in kernel
> community?  Does it better if people B could give some suggestions to
> help A to improve the code, especially if those help would help A stepping
> into the kernel development -- maybe it's depend largely on one's opinion. :(

This is a completely different issue from the one in this thread, but it
is also a legitimate issue and honestly, a bigger one than perceived
insults.

Is it proper collaboration? Absolutely not. Something that I try to be
sensitive to as it's something I can do as well. There's been things on
my todo list, where someone would send me patches that do it. I would be
thinking "darn it, I wanted to do it" and even worse, the patches that
were sent wouldn't be of the way I wanted them. But I've tried to be
good, and instead of just going about and implementing it myself, I
would try to help the person massage the patches into what I wanted.
That takes a lot of effort and discipline, and honestly, helping someone
else do the work you wanted is much harder than just doing it yourself. 

Sometimes the maintainer just takes the easier route, and does the work
themselves (because it's also more fun too). But that's really a slap in
the face of the person that submitted the work in the first place. If
anything hurts the community, it's this behavior. Not Linus giving
someone an ass wipe.

-- Steve
 

