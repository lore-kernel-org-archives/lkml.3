Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3DMAJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:09:50 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40303 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DMAJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:09:49 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 12 Apr 2013 17:09:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/2] SRCU changes for 3.11
Message-ID: <20130413000939.GC8140@jtriplet-mobl1>
References: <20130412233815.GA22914@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412233815.GA22914@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:38:15PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides some SRCU changes:
> 
> 1.	Remove srcu_read_lock_raw() and srcu_read_unlock_raw().  These
> 	never did get used, and have not been used for some time, so
> 	it is time for them to go.
> 
> 2.	Fix a bug where srcu_read_lock() is not released upon return
> 	from kvmppc_hv_setup_htab_rma().

For both:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
