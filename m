Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaJCPPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:15:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54249 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaJCPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:15:03 -0400
Date: Fri, 3 Oct 2014 17:14:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v6 3/6] sched: add utilization_avg_contrib
Message-ID: <20141003151451.GJ10583@worktop.programming.kicks-ass.net>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-4-git-send-email-vincent.guittot@linaro.org>
 <20141003143634.GL2849@worktop.programming.kicks-ass.net>
 <CAKfTPtDvX=JFf6OBBzTVbo6C76p243za+9CkL-ofSOvHQS5-mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDvX=JFf6OBBzTVbo6C76p243za+9CkL-ofSOvHQS5-mQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 04:51:01PM +0200, Vincent Guittot wrote:
> On 3 October 2014 16:36, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> +      * utilization_load_avg is the sum of the average running time of the
> >> +      * sched_entities on the rq.
> >>        */
> >
> > So I think there was some talk about a blocked_utilization thingy, which
> > would track the avg running time of the tasks currently asleep, right?
> >
> 
> yes. Do you mean that we should anticipate and rename
> utilization_load_avg into utilization_runnable_avg to make space for a
> utilization_blocked_avg that could be added in future ?

nah, just trying to put things straight in my brain, including what is
'missing'.
