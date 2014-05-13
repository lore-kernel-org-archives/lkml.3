Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbaEMHe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:34:29 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15573 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753097AbaEMHe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:34:27 -0400
X-IronPort-AV: E=Sophos;i="4.97,1042,1389715200"; 
   d="scan'208";a="30442306"
Message-ID: <5371BCF8.7030708@cn.fujitsu.com>
Date: Tue, 13 May 2014 15:34:32 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net> <20140513072208.GB7980@gmail.com>
In-Reply-To: <20140513072208.GB7980@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 04:22 PM, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> trace_sched_wakeup(.success) is a dead argument and has been for ages,
> Always 0, or random value?

Hi Ingo,

It is always 1 currently.

Peter believe that .success is not useful and I pointed that perf sched 
latency
is using it now. Then he post this patch to remove the usage here.

Please go to the following link for more about this issue.

https://lkml.org/lkml/2014/5/12/77

Thanx :)
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

