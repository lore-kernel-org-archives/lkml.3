Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3LJPYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:24:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59089 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3LJPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:24:34 -0500
Date: Tue, 10 Dec 2013 16:24:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, henrik@austad.us, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131210152430.GA1103@gmail.com>
References: <20131205105928.GA27382@austad.us>
 <20131205122851.GB20562@gmail.com>
 <20131205085146.0370ea2a@gandalf.local.home>
 <20131205.130524.997340443429884333.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205.130524.997340443429884333.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Thu, 5 Dec 2013 08:51:46 -0500
> 
> > I wish vger wouldn't do that. I wonder how much spam is really flagged
> > by this one characteristic alone. That is, spam that would have made it
> > otherwise, but because of the Cc list, it was rejected.
> 
> 10 to 20 spam posts per day are prevented by this rule.
> 
> And frankly it's totally rediculous to have such a huge CC: list
> in the first place, even if the vger spam filter didn't exist.

Absolutely agreed - in fact huge Cc: lists are a PITA when committing 
patches: I have to trim them down to something reasonable, without 
losing important Cc: entries ...

So vger is doing us a service there, and not just by filtering spam.

Thanks,

	Ingo
