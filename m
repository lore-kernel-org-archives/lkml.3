Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaAOWWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:22:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:59429 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbaAOWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:22:48 -0500
Date: Wed, 15 Jan 2014 23:22:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v2 tip/core/timers] Crude timer-wheel latency hacks
In-Reply-To: <20140115051939.GA31164@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1401152316500.4207@ionos.tec.linutronix.de>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, 14 Jan 2014, Paul E. McKenney wrote:
> The following three patches provide some crude timer-wheel latency
> patches.  I understand that a more comprehensive solution is in progress,
> but in the meantime, these patches work well in cases where a given
> CPU has either zero or one timers pending, which is a common case for
> NO_HZ_FULL kernels.  So, on the off-chance that this is helpful to
> someone, the individual patches are as follows:

so far that makes sense, though I'd rather like to redesign the whole
timer wheel mess than adding more duct tape to it. I can't dig into
the details right now as I'm dead tired and about to leave for a
funeral. i'll have a detailed look at this at the weekend.

Thanks,

	tglx


