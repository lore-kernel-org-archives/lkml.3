Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3CUTDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:03:22 -0400
Received: from a10-78.smtp-out.amazonses.com ([54.240.10.78]:33520 "EHLO
	a10-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268Ab3CUTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:03:21 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 15:03:21 EDT
Date: Thu, 21 Mar 2013 18:53:22 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: paulmck@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
In-Reply-To: <1363891462.6345.52.camel@gandalf.local.home>
Message-ID: <0000013d8e4c5d16-505199e0-9117-48e5-9280-951b42797209-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com> <1363636794.15703.32@driftwood> <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com> <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com> <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com> <20130321171518.GW3637@linux.vnet.ibm.com> <1363891462.6345.52.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 54.240.10.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Steven Rostedt wrote:

> For now, no, if more than one process is scheduled on the CPU, we fall
> out of dynamic tick mode. In the future, we can add SCHED_FIFO task
> scheduled in to trigger it. But lets conquer that after we successfully
> conquer the current changes.

Be glad to see whatever is possible merged as soon as possible. But be
aware that we will fall out of dyntick mode at mininum every 2 seconds
because that is when the per cpu vm stats and the slab scanning is
occurring. These are both deferrable activities.


