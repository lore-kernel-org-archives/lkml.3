Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaEaUD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:03:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:18614 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752165AbaEaUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:03:28 -0400
Date: Sat, 31 May 2014 16:03:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 4/5] rtmutex: Clarify the lock chain walk
Message-ID: <20140531160326.3be74259@gandalf.local.home>
In-Reply-To: <20140531155739.430525601@linutronix.de>
References: <20140531155229.493650009@linutronix.de>
	<20140531155739.430525601@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014 15:57:51 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Add a separate local variable for the boost/deboost logic to make the
> code more readable. Add comments where appropriate.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Link: http://lkml.kernel.org/r/20140522031950.168005692@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

