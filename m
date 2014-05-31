Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbaEaCVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:21:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28893 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932229AbaEaCVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:21:40 -0400
Date: Fri, 30 May 2014 22:21:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Low <jason.low2@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 6/6] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
Message-ID: <20140530222138.1db0d706@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1405281143000.21720@ionos.tec.linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031950.280830190@linutronix.de>
	<CAGQ1y=6DOs0hcdV+NvOdA9hxf6kwu-R0M-c6R2iUK4ufr=pwEg@mail.gmail.com>
	<alpine.DEB.2.02.1405281143000.21720@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 11:43:16 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

[snip]

> > 
> > In the above case, could we go 1 step further and avoid taking the pi
> > lock as well?

[snip]

> 
> Indeed.
> 
>  

Are you going to repost this patch? I'd like to review that one instead
of this one if you're going to make such a charge.


Thanks,

-- Steve
