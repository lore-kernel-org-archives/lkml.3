Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaIQPJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:09:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59724 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaIQPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:09:42 -0400
Date: Wed, 17 Sep 2014 08:09:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Clark Williams <clark.williams@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
Message-ID: <20140917150937.GV4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140915100524.2cd80d2e@sluggy>
 <20140916204156.GP4723@linux.vnet.ibm.com>
 <20140917081442.60425e2d@sluggy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917081442.60425e2d@sluggy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091715-6688-0000-0000-000004E185AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 08:14:42AM -0500, Clark Williams wrote:
> On Tue, 16 Sep 2014 13:41:56 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Mon, Sep 15, 2014 at 10:05:24AM -0500, Clark Williams wrote:
> > > Paul,
> > > 
> > > Here's the result of our conversation Friday, regarding the per-CPU and
> > > boost priorities:
> > > 
> > > Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> > > value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> > > threads (rcub/n).
> > > 
> > > Also, create the module_parameter rcutree.kthread_prio to be used on
> > > the kernel command line at boot to set a new value
> > > (rcutree.kthread_prio=N).
> > > 
> > > Signed-off-by: Clark Williams <clark.williams@gmail.com>
> > 
> > Thank you, Clark!
> > 
> > I queued this, porting to rcu/dev, which resulted in the following
> > patch.  Please check this to make sure it still reflects your intent.
> > In the meantime, I will start testing.
> > 
> > 							Thanx, Paul
> 
> Yes, looks right (and you fixed that I didn't have it all under
> RCU_BOOST). 

Very good!  Early testing looks good, will let you know how it goes.

							Thanx, Paul

