Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaBIMor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:44:47 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43254 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBIMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:44:46 -0500
Date: Sun, 9 Feb 2014 13:44:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/wait: suppress sparse 'variable shadowing' warning
Message-ID: <20140209124442.GA21967@gmail.com>
References: <20140206111346.712edc04@gandalf.local.home>
 <1391704121.12789.20.camel@jlt4.sipsolutions.net>
 <20140206164558.GV2936@laptop.programming.kicks-ass.net>
 <20140206115252.230094a1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206115252.230094a1@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 6 Feb 2014 17:45:58 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, Feb 06, 2014 at 05:28:41PM +0100, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > This warning seems to show up a lot now, since ___wait_event()
> > > is (indirectly) used inside wait_event_timeout(), which also
> > > has a variable called __ret. Rename the one in ___wait_event()
> > > to ___ret (another leading underscore) to suppress the warning.
> > > 
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > 
> > Thanks!
> 
> Tag, you're it!
> 
> Now you need to submit a patch to fix one sparse warning this week ;-)
> 
> Yeah, yeah, I know. Like you have time.
> 
> This could be a cool drinking game. Every time you fix someone else's
> sparse error, they have to drink a pint :-)

... which game would result in a heightened mood amongst developers 
and even more Sparse errors, resulting in more fixes from PeterZ and 
more pints downed, creating a nice feedback loop. Sounds like fun for 
everyone, except Peter? ;-)

Thanks,

	Ingo
