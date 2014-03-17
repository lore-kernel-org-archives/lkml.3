Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaCQGnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:43:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:22572 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751107AbaCQGnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:43:00 -0400
Message-ID: <1395038574.4574.7.camel@pippen.local.home>
Subject: Re: [RFA][PATCH 3/4] tracing/module: Remove include of tracepoint.h
 from module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 17 Mar 2014 02:42:54 -0400
In-Reply-To: <87fvmhtuwg.fsf@rustcorp.com.au>
References: <20140226190140.590029589@goodmis.org>
	 <20140226190644.730153889@goodmis.org>
	 <20140226221335.3e30572a@gandalf.local.home>
	 <87fvmhtuwg.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 13:04 +1030, Rusty Russell wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> > On Wed, 26 Feb 2014 14:01:43 -0500
> > Hi Rusty,
> >
> > This patch doesn't need to be stable, and can wait till v3.15. But I
> > have other patches that will break with this patch (headers that needed
> > to include tracepoint.h and not depend on a header chain to include it).
> >
> > Can you give me your Acked-by for this, and I'll just add it to my 3.15
> > queue?
> 
> Cleaning up old mail, in case I didn't ack this:
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Yep, you already gave me your ack. But I appreciate the double ack :-)

-- Steve


