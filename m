Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbaGSDaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 23:30:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26208 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757255AbaGSDaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 23:30:19 -0400
Date: Fri, 18 Jul 2014 23:30:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
Message-ID: <20140718233010.620d7a79@gandalf.local.home>
In-Reply-To: <alpine.LFD.2.11.1407182249020.3647@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
	<1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
	<20140718160418.54d11f6a@gandalf.local.home>
	<alpine.LFD.2.11.1407181652080.3647@knanqh.ubzr>
	<20140718172221.6dbe83e4@gandalf.local.home>
	<alpine.LFD.2.11.1407182249020.3647@knanqh.ubzr>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 22:55:12 -0400 (EDT)
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

> Any comments / ACKs on the other patches?  I'd like to see 1/4 to 3/4 
> (and your patch) merged upstream during the next window.  4/4 is up for 
> debate.

You can add my Acked-by for patches 1,2 and 3, after the clean up of
the #ifdefs there.

I still don't like the fact that you need to add the #undef in patch 4.
I'm looking at other ways to fix that. I tried to do a few different
clean ups in the tracing infrastructure, but it seems that it may be
required. The other method I may try is to move the #undefs into the
ipi.h header itself.

I'll play more with this on Monday.

-- Steve
