Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaEUKD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:03:56 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:35767 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaEUKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140404125249.GC10526@twins.programming.kicks-ass.net>
References: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140404125249.GC10526@twins.programming.kicks-ass.net>
Date: Wed, 21 May 2014 18:03:53 +0800
Message-ID: <CA+qeAOp5G94n5d1wOGe876d1HkSTVxN9hVbr9jLhGmSGvsAtJA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix tracepoint in scheduler.
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, did you forget to take this patch? :-)

On Fri, Apr 4, 2014 at 8:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Apr 03, 2014 at 08:12:48PM +0800, Dongsheng Yang wrote:
>> In function set_task_cpu(), if cpu == new_cpu,
>> there is no migration happen. But current trace point
>> will raise a migration trace event.
>>
>> This patch change trace point to right place,
>> only when migration really happen, an event will
>> be threw out.
>
> Yeah its there so we can see pointless 'migrations'.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
