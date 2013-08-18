Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3HRC7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:59:49 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48305 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3HRC7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:59:47 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 19:59:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/5] rcutorture updates for 3.12
Message-ID: <20130818025939.GF28923@leaf>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818022453.GA3475@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 07:24:53PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides some rcutorture updates:
> 
> 1.	Add a debug_object option to rcutorture to allow testing
> 	of RCU's debug-objects facilities.
> 
> 2.	Increase rcutorture test coverage by concurrently testing
> 	synchronous, asynchronous, and expedited grace periods.
> 
> 3.	Sort the extensive list of rcutorture module parameters.
> 
> 4.	Remove the unused "oldbatch" variable.
> 
> 5.	Emit CPU-online failure message to the console.

Comments on 1 and 3; for 2, 4, and 5:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
