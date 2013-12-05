Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab3LESFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:05:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56110 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab3LESFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:05:31 -0500
Date: Thu, 05 Dec 2013 13:05:24 -0500 (EST)
Message-Id: <20131205.130524.997340443429884333.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: mingo@kernel.org, henrik@austad.us, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131205085146.0370ea2a@gandalf.local.home>
References: <20131205105928.GA27382@austad.us>
	<20131205122851.GB20562@gmail.com>
	<20131205085146.0370ea2a@gandalf.local.home>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 10:05:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 5 Dec 2013 08:51:46 -0500

> I wish vger wouldn't do that. I wonder how much spam is really flagged
> by this one characteristic alone. That is, spam that would have made it
> otherwise, but because of the Cc list, it was rejected.

10 to 20 spam posts per day are prevented by this rule.

And frankly it's totally rediculous to have such a huge CC: list
in the first place, even if the vger spam filter didn't exist.

If you CC: something to netdev, it's going to reach me, you don't need
to CC: me.  If just makes for a dup that I have to delete in my inbox,
so you're actually making more work for me in the end.

That's just one example.
