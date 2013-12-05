Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3LEM25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:28:57 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45549 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3LEM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:28:56 -0500
Date: Thu, 5 Dec 2013 13:28:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Henrik Austad <henrik@austad.us>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131205122851.GB20562@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <20131205105928.GA27382@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205105928.GA27382@austad.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrik Austad <henrik@austad.us> wrote:

> On Wed, Dec 04, 2013 at 02:46:28PM -0800, Paul E. McKenney wrote:
> > Hello!
> 
> Hi Paul,
> 
> > This series applies some long-needed updates to memory-barriers.txt:
> > 
> > 1.	Add ACCESS_ONCE() calls where needed to ensure their inclusion
> > 	in code copy-and-pasted from this file.
> > 
> > 2.	Add long atomic examples alongside the existing atomics.
> > 
> > 3.	Prohibit architectures supporting the Linux kernel from
> > 	speculating stores.
> 
> Just me, or is the 3rd patch missing from lkml?

It had a Cc: list from hell so vger probably rejected it as spam.

Thanks,

	Ingo
