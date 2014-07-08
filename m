Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaGHAPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:15:07 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46230 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaGHAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:14:49 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 7 Jul 2014 17:14:35 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/4] Documentation changes for 3.17
Message-ID: <20140708001435.GC19213@jtriplet-mobl1>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707222345.GA6320@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:23:45PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a few documentation updates:
> 
> 1.	Clarify that if there is nothing awakened, then there is no
> 	memory barrier.
> 
> 2.	Fix broken RTFP URL, courtesy of Pranith Kumar.
> 
> 3.	Add acquire/release barrier to memory-barrier pairing rules.
> 
> 4.	Add pointer to percpu-ref in rcuref.txt documentation.

For all four:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
