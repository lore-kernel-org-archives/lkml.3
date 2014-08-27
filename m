Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbaH0XY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:24:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37795 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965120AbaH0XY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:24:27 -0400
Date: Wed, 27 Aug 2014 16:24:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] rcu: Make nocb leader kthreads process pending callbacks
 after spawning
Message-ID: <20140827232422.GQ2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1409172220-2804-1-git-send-email-bobby.prani@gmail.com>
 <20140827214706.GO2663@linux.vnet.ibm.com>
 <CAJhHMCB2bCYXkE6yrygKx=k46n4SN+iDtJR+N14CcYu5LRFLEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCB2bCYXkE6yrygKx=k46n4SN+iDtJR+N14CcYu5LRFLEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082723-7164-0000-0000-0000042547A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 07:08:37PM -0400, Pranith Kumar wrote:
> On Wed, Aug 27, 2014 at 5:47 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Thank you, Pranith, queued.  I have also backported to v3.17-rc2,
> > and am testing both.  A sneak preview of the backport is shown below,
> > please let me know if you see any problems with it.  (The reason for
> > the backport is to submit to 3.17 as a fix for a regression.)
> 
> Looks good to me!

And both versions pass short rcutorture tests.

Amit, could you please try running your test with the backported
version of the patch?  One more time?

							Thanx, Paul

