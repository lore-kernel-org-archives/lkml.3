Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaBFQw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:52:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:50076 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755941AbaBFQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:52:54 -0500
Date: Thu, 6 Feb 2014 11:52:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/wait: suppress sparse 'variable shadowing'
 warning
Message-ID: <20140206115252.230094a1@gandalf.local.home>
In-Reply-To: <20140206164558.GV2936@laptop.programming.kicks-ass.net>
References: <20140206111346.712edc04@gandalf.local.home>
	<1391704121.12789.20.camel@jlt4.sipsolutions.net>
	<20140206164558.GV2936@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014 17:45:58 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Feb 06, 2014 at 05:28:41PM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > This warning seems to show up a lot now, since ___wait_event()
> > is (indirectly) used inside wait_event_timeout(), which also
> > has a variable called __ret. Rename the one in ___wait_event()
> > to ___ret (another leading underscore) to suppress the warning.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Thanks!

Tag, you're it!

Now you need to submit a patch to fix one sparse warning this week ;-)

Yeah, yeah, I know. Like you have time.

This could be a cool drinking game. Every time you fix someone else's
sparse error, they have to drink a pint :-)

-- Steve
