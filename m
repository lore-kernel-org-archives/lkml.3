Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaGGOy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:54:56 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65036 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGGOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:54:55 -0400
Message-ID: <1404744889.4709.83.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.4.10-rt7
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Carsten Emde <cbe@osadl.org>
Date: Mon, 07 Jul 2014 16:54:49 +0200
In-Reply-To: <alpine.DEB.2.10.1407071027170.22031@nanos>
References: <alpine.DEB.2.10.1407071027170.22031@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 14:47 +0200, Thomas Gleixner wrote: 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.14.10-rt7 release. 3.14.10-rt6 is a not
> announced update to 3.14.10 without any RT changes aside of resolving
> the patch conflicts.
> 
> Changes since 3.14.10-rt6:
> 
>    * Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq() -
>      from Steven
> 
>    * Prevent workqueue deadlock/stall observed with XFS
> 
> 
> A few words on the status and the future of RT:
> -----------------------------------------------
> 
> The situation since last years RTLWS (https://lwn.net/Articles/572740/)
> has not improved at all, it's worse than before. 
> 
> While shortly after RTLWS quite some people promised to whip up proper
> funding, nothing has materialized and my personal situation is worse
> than before.

Sorry to hear that funding hasn't as yet happened.

> I'm really tired of all the politics involved, the blantant lies and
> the marketing bullshit which I have to bear. I learned a few month ago
> that a certain kernel vendor invented most of RT anyway and is the
> expert in this field, so the customers dont have to worry about my
> statements.

Wow, so someone thinks their customers either can't or won't read.  That
kind of marketing can backfire in a big way.

-Mike


