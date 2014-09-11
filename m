Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaIKOEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:04:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:56354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaIKOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:04:49 -0400
Date: Thu, 11 Sep 2014 16:04:44 +0200
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
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v5 10/12] sched: get CPU's utilization statistic
Message-ID: <20140911140444.GH4783@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-11-git-send-email-vincent.guittot@linaro.org>
 <20140911123412.GY3190@worktop.ger.corp.intel.com>
 <CAKfTPtBbjpCFifoyFSh8Hb3nBZFFTjjxdfxnpMk=CHy5aX1qpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBbjpCFifoyFSh8Hb3nBZFFTjjxdfxnpMk=CHy5aX1qpg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:07:52PM +0200, Vincent Guittot wrote:
> > Also I'm not entirely sure I like the usage, utilization names/metrics.
> > I would suggest to reverse them. Call the pure running number
> > 'utilization' and this scaled with capacity 'usage' or so.
> 
> ok. i can invert 'usage' and 'utilization', which will give
> 
> s/get_cpu_utilization/get_cpu_usage/
> s/sgs->group_utilization/sgs->group_usage/
> s/cfs.usage_load_avg/cfs.utilization_load_avg/
> s/se->avg.usage_avg_contrib/se->avg.utilization_avg_contrib
> s/__update_task_entity_usage/__update_task_entity_utilization
> s/__update_entity_usage_avg_contrib/__update_entity_utilization_avg_contrib
> 

Any other opinions before Vince goes and applies sed on patches? ;-)
