Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab3GQWx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:53:56 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:51720 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166Ab3GQWxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:53:54 -0400
Date: Wed, 17 Jul 2013 18:53:51 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Javi Merino <javi.merino@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if UP
 system
In-Reply-To: <51E71C78.6080604@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1307171849180.14924@syhkavp.arg>
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org> <20130712111322.GC3213@e102654-lin.cambridge.arm.com> <20130712121023.GB27430@codeaurora.org> <51E71249.4050200@codeaurora.org> <alpine.LFD.2.03.1307171830170.14924@syhkavp.arg>
 <51E71C78.6080604@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Stephen Boyd wrote:

> On 07/17/13 15:34, Nicolas Pitre wrote:
> > On Wed, 17 Jul 2013, Stephen Boyd wrote:
> >
> >> On 07/12/13 05:10, Stephen Boyd wrote:
> >>> On 07/12, Javi Merino wrote:
> >>>> I agree, we should drop the check.  It's annoying in uniprocessors and
> >>>> unlikely to be found in the real world unless your gic entry in the dt
> >>>> is wrong.
> > And that's a likely outcome in the real world.
> >
> >>> Ok. How about this?
> >> Any comments?
> > What about this instead:
> 
> Unfortunately arm64 doesn't have SMP_ON_UP. 

And why does that matter?

> It sounds like you preferred the first patch using num_possible_cpus()

Probably, yes.  I didn't follow the early conversation though.


Nicolas
