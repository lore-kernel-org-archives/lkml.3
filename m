Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaFCVz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:55:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaFCVz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:55:28 -0400
Date: Tue, 3 Jun 2014 14:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-Id: <20140603145526.f78e1cb7462048376709b6f0@linux-foundation.org>
In-Reply-To: <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
References: <20140603114821.GA23711@gmail.com>
	<1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014 14:50:51 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > The main changes in this cycle were:
> > 
> >  - reduced/streamlined smp_mb__*() interface that allows more usecases 
> >    and makes the existing ones less buggy, especially in rarer 
> >    architectures
> > 
> >  - add rwsem implementation comments
> > 
> >  - bump up lockdep limits
> 
> So I guess the rwsem optimistic spinning stuff will be routed through
> akpm then (which is already in -next for a while, through -mm).

I'd prefer not - I put it in there just to get some linux-next exposure.
A change like this should be carefully poked at by people who understand
what they're poking.
