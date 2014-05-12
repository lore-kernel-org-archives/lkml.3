Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbaELPRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:17:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54209 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758430AbaELPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:17:51 -0400
Date: Mon, 12 May 2014 11:17:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <dongsheng081251@gmail.com>,
        "yangds.fnst" <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140512111748.1c2f6cd9@gandalf.local.home>
In-Reply-To: <20140512150950.GP30445@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
	<1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140510152902.GW11096@twins.programming.kicks-ass.net>
	<536F90BE.2080806@gmail.com>
	<CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
	<20140511163531.GG30445@twins.programming.kicks-ass.net>
	<20140511145224.00412e59@gandalf.local.home>
	<20140512064730.GI30445@twins.programming.kicks-ass.net>
	<20140512100908.07cc50bc@gandalf.local.home>
	<20140512150950.GP30445@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 17:09:50 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > Point being, this is useful information, why not pass it to userspace?
> 
> Because it adds code to one of the hottest code paths in the kernel and
> so far nobody had a sane explanation of WTF they were doing.
> 

Is there a measurable difference with these extra tracepoints?

-- Steve

