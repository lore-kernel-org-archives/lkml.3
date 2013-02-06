Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3BFLtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:49:31 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44954 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3BFLta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:49:30 -0500
Date: Wed, 6 Feb 2013 12:49:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130206114925.GF8696@gmail.com>
References: <20130204171817.GA18332@linux.vnet.ibm.com>
 <20130204180734.GA10022@gmail.com>
 <20130204193041.GA16853@gmail.com>
 <20130204202523.GZ2632@linux.vnet.ibm.com>
 <20130205141124.GA12785@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205141124.GA12785@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., I got a non-trivial conflicts in 
kernel/context_tracking.c, with the following commits 
interacting between the RCU tree (tip:core/rcu) and the 
scheduler tree (tip:sched/core):

 6a61671bb2f3 cputime: Safely read cputime of full dynticks CPUs
 abf917cd91cb cputime: Generic on-demand virtual cputime accounting
 4eacdf18374e context_tracking: Add comments on interface and internals
 95a79fd458b8 context_tracking: Export context state for generic vtime

I think I managed to resolve the conflicts (will push it out in 
an hour or two, after some testing) - but please double check me 
on it...

Thanks,

	Ingo
