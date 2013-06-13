Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3FMPu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab3FMPu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:50:28 -0400
Date: Thu, 13 Jun 2013 10:02:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130613140207.GW133453@redhat.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
 <20130612170316.GO133453@redhat.com>
 <20130613131057.GA15997@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613131057.GA15997@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:10:59PM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 12, 2013 at 01:03:16PM -0400, Don Zickus wrote:
> > On Wed, Jun 12, 2013 at 04:02:36PM +0200, Frederic Weisbecker wrote:
> > > When the watchdog runs, it prevents the full dynticks
> > > CPUs from stopping their tick because the hard lockup
> > > detector uses perf events internally, which in turn
> > > rely on the periodic tick.
> > > 
> > > Since this is a rather confusing behaviour that is not
> > > easy to track down and identify for those who want to
> > > test CONFIG_NO_HZ_FULL, let's default disable the
> > > watchdog on boot time when full dynticks is enabled.
> > > 
> > > The user can still enable it later on runtime using
> > > proc or sysctl.
> > 
> > I thought we had a conversation awhile ago, where we agreed this was going
> > to be fixed for 3.11?  Didn't Peter find the patch and apply it to his
> > tree?  I am confused why this is still needed?
> 
> We agreed on the patch but it hasn't been applied yet. I'm trying to get
> a sane series of nohz patches before sending to Ingo.

Peter,

Where is this patch?

Cheers,
Don
