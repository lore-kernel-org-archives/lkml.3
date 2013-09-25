Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3IYN4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:56:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44020 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab3IYN4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:56:03 -0400
Date: Wed, 25 Sep 2013 06:55:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation updates for 3.13
Message-ID: <20130925135548.GT9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925011657.GA29958@linux.vnet.ibm.com>
 <20130925034818.GB2016@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925034818.GB2016@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092513-5806-0000-0000-000022D8A91F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 08:48:18PM -0700, Josh Triplett wrote:
> On Tue, Sep 24, 2013 at 06:16:57PM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This series provides a few documentation updates:
> > 
> > 1.	Update stall-warning documentation to catch up with recent updates.
> > 
> > 2.	Add a reference to the new vmstat-avoidance patch to the
> > 	file describing how to quiet per-CPU kthreads.
> > 
> > 3.	Fix a typo in Documentation/RCU/checklist.txt, courtesy of
> > 	Michael Opdenacker.
> 
> I replied to 3 with a comment; for 1 and 2:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you for the review, applied to 1 and 2.

							Thanx, Paul

