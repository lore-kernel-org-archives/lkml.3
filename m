Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3LELAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:00:23 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45648 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3LELAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:00:22 -0500
Date: Thu, 5 Dec 2013 11:59:28 +0100
From: Henrik Austad <henrik@austad.us>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131205105928.GA27382@austad.us>
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

Hi Paul,

> This series applies some long-needed updates to memory-barriers.txt:
> 
> 1.	Add ACCESS_ONCE() calls where needed to ensure their inclusion
> 	in code copy-and-pasted from this file.
> 
> 2.	Add long atomic examples alongside the existing atomics.
> 
> 3.	Prohibit architectures supporting the Linux kernel from
> 	speculating stores.

Just me, or is the 3rd patch missing from lkml?

> 4.	Document what ACCESS_ONCE() does along with a number of situations
> 	requiring its use.

This was very useful, thanks! :)

-- 
Henrik Austad
