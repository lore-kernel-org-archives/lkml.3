Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbaH0NNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:13:17 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50697 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbaH0NNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:13:16 -0400
Date: Wed, 27 Aug 2014 18:42:45 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, riel@redhat.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 04/12] sched: Allow all archs to set the capacity_orig
Message-ID: <20140827131208.GB13808@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082713-0013-0000-0000-000000285F5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vincent Guittot <vincent.guittot@linaro.org> [2014-08-26 13:06:47]:

> capacity_orig is only changed for system with a SMT sched_domain level in order
> to reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
> original capacity that is different from the default value.
> 
> Create a more generic function arch_scale_cpu_capacity that can be also used by
> non SMT platform to set capacity_orig.
> 
> The weak behavior of arch_scale_cpu_capacity is the previous SMT one in order to
> keep backward compatibility in the use of capacity_orig.
> 
> arch_scale_smt_capacity and default_scale_smt_capacity have been removed as
> they were not use elsewhere than in arch_scale_cpu_capacity.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

