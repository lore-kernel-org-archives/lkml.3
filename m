Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3LEALJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:11:09 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34852 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab3LEALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:11:07 -0500
X-Originating-IP: 173.246.103.110
Date: Wed, 4 Dec 2013 16:10:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131205001054.GB28492@jtriplet-mobl1>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204224628.GA30159@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:46:28PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> This series applies some long-needed updates to memory-barriers.txt:
> 
> 1.	Add ACCESS_ONCE() calls where needed to ensure their inclusion
> 	in code copy-and-pasted from this file.
> 
> 2.	Add long atomic examples alongside the existing atomics.
> 
> 3.	Prohibit architectures supporting the Linux kernel from
> 	speculating stores.
> 
> 4.	Document what ACCESS_ONCE() does along with a number of situations
> 	requiring its use.

For all four patches in v4:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
