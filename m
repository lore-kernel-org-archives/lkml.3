Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaL3Sue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 13:50:34 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaL3Suc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 13:50:32 -0500
Date: Tue, 30 Dec 2014 19:50:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Scott Wood <scottwood@freescale.com>,
        Anton Blanchard <anton@samba.org>, Daniel Walter <dwalter@google.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] srcu: Isolate srcu sections using CONFIG_SRCU
Message-ID: <20141230185008.GA23965@worktop.programming.kicks-ass.net>
References: <1419918382-4758-1-git-send-email-bobby.prani@gmail.com>
 <1419918382-4758-2-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419918382-4758-2-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 12:46:22AM -0500, Pranith Kumar wrote:
> Isolate the SRCU functions and data structures within CONFIG_SRCU so that there
> is a compile time failure if srcu is used when not enabled. This was decided to
> be better than waiting until link time for a failure to occur.

Why?
