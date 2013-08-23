Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3HWK5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:57:14 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35569 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3HWK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:57:13 -0400
Message-ID: <52173F5F.9080706@linux.vnet.ibm.com>
Date: Fri, 23 Aug 2013 16:24:23 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 07/10] sched, fair: Optimize find_busiest_queue()
References: <20130819160058.539049611@infradead.org> <20130819160425.527872672@infradead.org> <5217194B.2020209@linux.vnet.ibm.com> <20130823100340.GP31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130823100340.GP31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082310-1618-0000-0000-000004810E4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 03:33 PM, Peter Zijlstra wrote:
> On Fri, Aug 23, 2013 at 01:41:55PM +0530, Preeti U Murthy wrote:
>> Hi Peter,
>>
>> On 08/19/2013 09:31 PM, Peter Zijlstra wrote:
>>
>> In the load balancing code, looks to me that
>> cpumask_copy(cpus, cpu_active_mask) is not updating the env.cpus at all,
>> before calling find_busiest_group(). Am I missing something?
>>
>> Should not cpumask_copy() below be before we update the env.cpus parameter?
> 
> Nah, its all pointers.
> 

Yikes! Of course :P

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

