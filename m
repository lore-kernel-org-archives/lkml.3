Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3GYMSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:18:39 -0400
Received: from mout.gmx.net ([212.227.17.22]:57655 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696Ab3GYMSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:18:37 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
Date: Thu, 25 Jul 2013 14:18:22 +0200
Message-ID: <62503268.QbpPrBijRc@aragorn.auenland.lan>
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.16-default; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51E9A861.4040803@hp.com>
References: <20130719183101.GA20909@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1307192139140.4089@ionos.tec.linutronix.de> <51E9A861.4040803@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:+mIl/Ce1rGrYkCNAXz4SzIquy4mPJ/eWWnoYMB78AVwOF+jJkGq
 0YHaeo/ddV7UuD5u2t5eWpdOgkcKdpZLHQAmf+ltresDciuMIFZC8ahkg/i6nS1G2vBufCK
 op1uF3EgC6TNpNJhrn9UUR6TCGz6Sor/cIVM783yIPU/jfcWCQb57mY/swZTMX1hi4nI5XP
 iQvLq4p79oso//ZMEjoRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 July 2013 16:58:09 Waiman Long wrote:
> 
> I supposed that only the gcc compiler can be used to build Linux kernel
> as the kernel source uses a lot of features specific to gcc.

Look at  http://llvm.linuxfoundation.org  -  they're using clang with more and 
more success.

--
JS

