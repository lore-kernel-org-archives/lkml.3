Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3IYDse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:48:34 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37033 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab3IYDsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:48:33 -0400
X-Originating-IP: 50.43.39.152
Date: Tue, 24 Sep 2013 20:48:18 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation updates for 3.13
Message-ID: <20130925034818.GB2016@leaf>
References: <20130925011657.GA29958@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925011657.GA29958@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 06:16:57PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a few documentation updates:
> 
> 1.	Update stall-warning documentation to catch up with recent updates.
> 
> 2.	Add a reference to the new vmstat-avoidance patch to the
> 	file describing how to quiet per-CPU kthreads.
> 
> 3.	Fix a typo in Documentation/RCU/checklist.txt, courtesy of
> 	Michael Opdenacker.

I replied to 3 with a comment; for 1 and 2:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
