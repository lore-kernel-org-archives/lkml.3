Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab3GPXMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:12:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:20450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637Ab3GPXMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:12:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,680,1367996400"; 
   d="scan'208";a="371424424"
Date: Tue, 16 Jul 2013 16:12:17 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Olivier Galibert <galibert@pobox.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML (was: [
 00/19] 3.10.1-stable review)
Message-ID: <20130716231217.GL4994@xanatos>
References: <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <1373926109.17876.221.camel@gandalf.local.home>
 <20130715223615.GI15531@xanatos>
 <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
 <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com>
 <20130716211235.GG4994@xanatos>
 <20130716212704.GB9371@thunk.org>
 <20130716224357.GK4994@xanatos>
 <1374015299.6458.76.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374015299.6458.76.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 06:54:59PM -0400, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 15:43 -0700, Sarah Sharp wrote:
> 
> > Yes, that's true.  Some kernel developers are better at moderating their
> > comments and tone towards individuals who are "sensitive".  Others
> > simply don't give a shit.  So we need to figure out how to meet
> > somewhere in the middle, in order to establish a baseline of civility.
> 
> I have to ask this because I'm thick, and don't really understand,
> but ...
> 
> What problem exactly are we trying to solve here?

Personal attacks are not cool Steve.  Some people simply don't care if a
verbal tirade is directed at them.  Others do not want anyone to attack
them personally, but they're fine with people attacking their code.

Bystanders that don't understand the kernel community structure are
discouraged from contributing because they don't want to be verbally
abused, and they really don't want to see either personal attacks or
intense belittling, demeaning comments about code.

In order to make our community better, we need to figure out where the
baseline of "good" behavior is.  We need to define what behavior we want
from both maintainers and patch submitters.  E.g. "No regressions" and
"don't break userspace" and "no personal attacks".  That needs to be
written down somewhere, and it isn't.  If it's documented somewhere,
point me to the file in Documentation.  Hint: it's not there.

That is the problem.

Sarah Sharp
