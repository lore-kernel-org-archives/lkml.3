Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaGTU0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:26:03 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37007 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaGTU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:26:00 -0400
Message-ID: <1405887954.11927.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/4] (RFC) X86: add IPI tracepoints
From: Davidlohr Bueso <davidlohr@hp.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Date: Sun, 20 Jul 2014 13:25:54 -0700
In-Reply-To: <1405660735-13408-5-git-send-email-nicolas.pitre@linaro.org>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
	 <1405660735-13408-5-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 01:18 -0400, Nicolas Pitre wrote:
> On X86 there are already tracepoints for IRQ vectors through which IPIs
> are handled.  However this is highly X86 specific, and the IPI signaling
> is not currently traced.
> 
> This is an attempt at adding generic IPI tracepoints to X86.

I welcome this, and fwiw have been trying out this patch. One thing I
would like to see, but due to overhead would probably be better suited
in userspace (trace-cmd, maybe?), is a more packed description of the
IPI. Ie: unifying ipi_init and ipi_exit and show overall cost of the
IPI.

Thanks,
Davidlohr

