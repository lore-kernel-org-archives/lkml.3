Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaGUWfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:35:41 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:56875 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaGUWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:35:39 -0400
Date: Mon, 21 Jul 2014 18:35:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 4/4] (RFC) X86: add IPI tracepoints
In-Reply-To: <1405887954.11927.5.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.LFD.2.11.1407211833330.3647@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org> <1405660735-13408-5-git-send-email-nicolas.pitre@linaro.org> <1405887954.11927.5.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2014, Davidlohr Bueso wrote:

> On Fri, 2014-07-18 at 01:18 -0400, Nicolas Pitre wrote:
> > On X86 there are already tracepoints for IRQ vectors through which IPIs
> > are handled.  However this is highly X86 specific, and the IPI signaling
> > is not currently traced.
> > 
> > This is an attempt at adding generic IPI tracepoints to X86.
> 
> I welcome this, and fwiw have been trying out this patch. One thing I
> would like to see, but due to overhead would probably be better suited
> in userspace (trace-cmd, maybe?), is a more packed description of the
> IPI. Ie: unifying ipi_init and ipi_exit and show overall cost of the
> IPI.

That's best suited for the tool consuming the log in user space.  The 
same is done with IRQ events already.


Nicolas
