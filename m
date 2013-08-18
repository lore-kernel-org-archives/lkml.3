Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3HRCsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:48:04 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50803 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3HRCr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:47:59 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 19:47:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation updates for 3.12
Message-ID: <20130818024742.GB28923@leaf>
References: <20130818012522.GA27015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818012522.GA27015@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:25:22PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a few documentation updates:
> 
> 1.	Update rcu_barrier() documentation to note that it no longer is
> 	guaranteed to wait for a full grace period.  This guarantee was
> 	a victim of energy efficiency.
> 
> 2.	Update RTFP documentation.
> 
> 3.	Fix a control-dependency example in the memory-barriers
> 	documentation.

For patches 1 and 3:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I replied to patch 2 with some comments.

- Josh Triplett
