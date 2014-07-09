Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaGILey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:34:54 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:60602 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaGILew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:34:52 -0400
Date: Wed, 9 Jul 2014 13:34:36 +0200
From: Henrik Austad <henrik@austad.us>
To: Pavel Vasilyev <pavel@pavlinux.ru>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Carsten Emde <cbe@osadl.org>
Subject: Re: [ANNOUNCE] 3.14.10-rt7
Message-ID: <20140709113436.GB26330@austad.us>
References: <alpine.DEB.2.10.1407071027170.22031@nanos>
 <alpine.DEB.2.10.1407071633460.22031@nanos>
 <53BD1316.5090901@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BD1316.5090901@pavlinux.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:01:58PM +0400, Pavel Vasilyev wrote:
> 07.07.2014 18:34, Thomas Gleixner пишет:
> >This time with proper Subject line :)
> >
> >Dear RT Folks,
> >
> >I'm pleased to announce the 3.14.10-rt7 release. 3.14.10-rt6 is a not
> >announced update to 3.14.10 without any RT changes aside of resolving
> >the patch conflicts.
> >
> >Changes since 3.14.10-rt6:
> >
> >    * Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq() -
> >      from Steven
> >
> >    * Prevent workqueue deadlock/stall observed with XFS
> >
> >
> >A few words on the status and the future of RT:
> >-----------------------------------------------
> >
> >The situation since last years RTLWS (https://lwn.net/Articles/572740/)
> >has not improved at all, it's worse than before.
> >
> >While shortly after RTLWS quite some people promised to whip up proper
> >funding, nothing has materialized and my personal situation is worse
> >than before.
> 
> Create site, add PayPal [DOANTE] button.

But.. where would they donate money?

Jokes aside, setting up an easy way to support the project wouldn't be such 
a bad idea. Is this something we (tglx) could talk (convince) 
linuxfoundation into hosting?

As said in the original mail, the kernel has benefited greatly from this 
effort over the last few years, making the effort more formal could help 
secure funding and let tglx et al focus on the task at hand and not on 
silly money issues.

Just my 0.1237 Norwegian krone.

-- 
Henrik Austad
