Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3CUTQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:16:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33012 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3CUTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:16:44 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=g1up7QdnZ3oA:10 a=4nr30O5rn4awQW_d50kA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363893402.6345.56.camel@gandalf.local.home>
Subject: Re: [PATCH] nohz1: Documentation
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: paulmck@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Date: Thu, 21 Mar 2013 15:16:42 -0400
In-Reply-To: <0000013d8e4c5d16-505199e0-9117-48e5-9280-951b42797209-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	 <1363636794.15703.32@driftwood>
	 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
	 <20130318222548.GG3656@linux.vnet.ibm.com>
	 <1363822338.6345.33.camel@gandalf.local.home>
	 <20130320235545.GL3637@linux.vnet.ibm.com>
	 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
	 <20130321171518.GW3637@linux.vnet.ibm.com>
	 <1363891462.6345.52.camel@gandalf.local.home>
	 <0000013d8e4c5d16-505199e0-9117-48e5-9280-951b42797209-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 18:53 +0000, Christoph Lameter wrote:
> On Thu, 21 Mar 2013, Steven Rostedt wrote:
> 
> > For now, no, if more than one process is scheduled on the CPU, we fall
> > out of dynamic tick mode. In the future, we can add SCHED_FIFO task
> > scheduled in to trigger it. But lets conquer that after we successfully
> > conquer the current changes.
> 
> Be glad to see whatever is possible merged as soon as possible. But be
> aware that we will fall out of dyntick mode at mininum every 2 seconds
> because that is when the per cpu vm stats and the slab scanning is
> occurring. These are both deferrable activities.
> 

Thanks for giving us the heads up.

Yeah, I understand your concern. Even when the current patch set is in,
I'm not claiming success. Just like how most of -rt is now in mainline.
It's not completely finished until the rest of -rt is there. I feel the
same with the dynamic tick patches. It will get in in stages. But it
truly isn't there until we have it  fully functional, that even you will
be pleased with the result ;-)

-- Steve


