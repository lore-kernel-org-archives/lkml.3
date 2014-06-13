Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaFMO5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbaFMO44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:56:56 -0400
Date: Fri, 13 Jun 2014 16:55:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140613145531.GA31794@redhat.com>
References: <alpine.DEB.2.10.1406102210580.5170@nanos> <20140611155251.GA4581@linux.vnet.ibm.com> <20140611170705.GA26816@redhat.com> <20140611171734.GA27457@redhat.com> <20140611172958.GF4581@linux.vnet.ibm.com> <20140611175934.GA28912@redhat.com> <20140611195613.GM4581@linux.vnet.ibm.com> <20140612172844.GA15795@redhat.com> <20140612203518.GZ4581@linux.vnet.ibm.com> <alpine.DEB.2.10.1406122337060.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406122337060.5170@nanos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Thomas Gleixner wrote:
>
> Just FYI, I have a patch pending which makes the release safe.
>
>       http://marc.info/?l=linux-kernel&m=140251240630730&w=2

Aha, great. I didn't see this version, and just in case I think it is fine.

Perhaps you can look at http://marc.info/?t=140207370200003 ?

Oleg.

