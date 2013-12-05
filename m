Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3LETCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:02:03 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41535 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3LETCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:02:01 -0500
Date: Thu, 5 Dec 2013 11:01:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, mingo@kernel.org, henrik@austad.us,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131205190138.GW15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131205085146.0370ea2a@gandalf.local.home>
 <20131205.130524.997340443429884333.davem@davemloft.net>
 <20131205181834.GV15492@linux.vnet.ibm.com>
 <20131205.134406.2030493811398343882.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205.134406.2030493811398343882.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120519-6688-0000-0000-00000433C421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 01:44:06PM -0500, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Thu, 5 Dec 2013 10:18:34 -0800
> 
> > The situation that leads me to use a large CC list is when I am doing
> > something that affects all architectures.  I could imagine keeping a
> > smallish CC list, then forwarding or bouncing the email to the remaining
> > maintainers  Would that work reasonably, or is there some better approach?
> 
> Please use linux-arch, that's what that list is for, notifying arch
> maintainers of changes that basically have an impact on every target.

Thank you, I have updated that commit as you suggested.

							Thanx, Paul

