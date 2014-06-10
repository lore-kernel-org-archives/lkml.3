Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936114AbaFJA1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:27:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:8700 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936091AbaFJA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:27:16 -0400
Date: Mon, 9 Jun 2014 20:27:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 0/7] rtmutex: Code clarification and optimization
Message-ID: <20140609202713.32e649ea@gandalf.local.home>
In-Reply-To: <20140609201118.387571774@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014 20:28:06 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> This is another round of clarification and optimization patches for
> the rtmutex code.
> 
> When I looked last week into the dead lock detector I spent some time
> to figure out how the various arguments and local variables are
> protected and whats the scope of the various protection algorithms, so
> I added documentation for this as well.
> 
> I also changed the last patch which avoids the requeueing in case of
> the deadlock detection only chain walk. Instead of adding tons of
> conditional to the boost/deboost code path I simply have a separate
> code path for it.

So what branch do these apply to? I tried latest Linus master and it
didn't apply.

-- Steve
