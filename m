Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3LESoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:44:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56518 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3LESoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:44:11 -0500
Date: Thu, 05 Dec 2013 13:44:06 -0500 (EST)
Message-Id: <20131205.134406.2030493811398343882.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: rostedt@goodmis.org, mingo@kernel.org, henrik@austad.us,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131205181834.GV15492@linux.vnet.ibm.com>
References: <20131205085146.0370ea2a@gandalf.local.home>
	<20131205.130524.997340443429884333.davem@davemloft.net>
	<20131205181834.GV15492@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 10:44:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 5 Dec 2013 10:18:34 -0800

> The situation that leads me to use a large CC list is when I am doing
> something that affects all architectures.  I could imagine keeping a
> smallish CC list, then forwarding or bouncing the email to the remaining
> maintainers  Would that work reasonably, or is there some better approach?

Please use linux-arch, that's what that list is for, notifying arch
maintainers of changes that basically have an impact on every target.
