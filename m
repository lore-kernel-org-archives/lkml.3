Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaHGPSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:18:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:43946 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757541AbaHGPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:18:37 -0400
Date: Thu, 7 Aug 2014 11:18:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 4/5] ARM64: add IPI tracepoints
Message-ID: <20140807111828.3c3d827a@gandalf.local.home>
In-Reply-To: <20140807091817.GG13703@arm.com>
References: <1406318733-26754-1-git-send-email-nicolas.pitre@linaro.org>
	<1406318733-26754-5-git-send-email-nicolas.pitre@linaro.org>
	<20140806155237.0a6d7d3c@gandalf.local.home>
	<20140807091817.GG13703@arm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 10:18:17 +0100
Will Deacon <will.deacon@arm.com> wrote:

> On Wed, Aug 06, 2014 at 08:52:37PM +0100, Steven Rostedt wrote:
> > Will and Russell,
> > 
> > Can you give me your Acked-by for this, and I can pull it through my
> > tree?
> 
> Looks fine to me:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
> I'm assuming there's a dependency on other patches going via the tracing
> tree, hence why you're taking this?

Yeah, there's some generic updates to the trace facility for these
tracepoints.

-- Steve
