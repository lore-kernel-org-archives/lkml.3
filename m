Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3F0Jm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:42:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52265 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3F0Jm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:42:58 -0400
Date: Thu, 27 Jun 2013 11:42:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
Message-ID: <20130627094226.GP28407@twins.programming.kicks-ass.net>
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <20130626122022.GI28407@twins.programming.kicks-ass.net>
 <20130626222442.GU3828@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626222442.GU3828@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:24:42PM -0700, Paul E. McKenney wrote:
> Just to make sure I understand...  You are saying that it is OK for
> NO_HZ_FULL to shut down timekeeping if all CPUs are idle, even if some
> of them are taking NMIs from time to time, right?

Yeah.. its what we currently do and I don't see any reason to have
NO_HZ_FULL behave differently there.


