Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbaE3Tpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:45:36 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57963 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaE3Tpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:45:35 -0400
Date: Fri, 30 May 2014 15:45:32 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher
 capacity
In-Reply-To: <CAKfTPtDWd5FKqSemFMFMMPz+t+aEnHWL_WH5grRoegtGnfD+bw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405301528530.17310@knanqh.ubzr>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org> <53888719.70604@arm.com> <CAKfTPtDWd5FKqSemFMFMMPz+t+aEnHWL_WH5grRoegtGnfD+bw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vincent Guittot wrote:

> On 30 May 2014 15:26, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> >> +     /*
> >> +      * The group capacity is reduced probably because of activity from other
> >
> > Here 'group capacity' refers to sgs->group_power and not to
> > sgs->group_capacity, right?
> 
> yes, you're right it's cpu_power, i will correct the comment

Note that peterz applied my rename patches so sgs->group_power has 
become sgs->group_capacity.


Nicolas
