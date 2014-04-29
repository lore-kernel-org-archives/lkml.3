Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaD2CrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:47:06 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36866 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaD2CrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:47:04 -0400
X-Originating-IP: 50.43.32.211
Date: Mon, 28 Apr 2014 19:46:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation changes for 3.16
Message-ID: <20140429024649.GA8465@thin>
References: <20140428233013.GA10816@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428233013.GA10816@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 04:30:13PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a few documentation updates:
> 
> 1.	Update sysfs patch for rcu_cpu_stall_suppress, courtesy of
> 	Kirill Tkhai.
> 
> 2.	Add a rcu_dereference.txt file documenting the proper care
> 	and feeding of rcu_dereference() return values.
> 
> 3.	Update the list of RCU API members in whatisRCU.txt.

For all three:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
