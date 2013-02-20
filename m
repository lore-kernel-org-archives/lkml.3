Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935307Ab3BTMUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:20:40 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35083 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934840Ab3BTMUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:20:39 -0500
Message-ID: <5124BF47.7070500@linux.vnet.ibm.com>
Date: Wed, 20 Feb 2013 17:49:19 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-7-git-send-email-alex.shi@intel.com>
In-Reply-To: <1361164062-20111-7-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022012-8256-0000-0000-0000064A2AC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 02/18/2013 10:37 AM, Alex Shi wrote:
> The cpu's utilization is to measure how busy is the cpu.
>         util = cpu_rq(cpu)->avg.runnable_avg_sum
>                 / cpu_rq(cpu)->avg.runnable_avg_period;

Why not cfs_rq->runnable_load_avg? I am concerned with what is the right
metric to use here.
Refer to this discussion:https://lkml.org/lkml/2012/10/29/448

Regards
Preeti U Murthy

