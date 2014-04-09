Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbaDIScZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:32:25 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51304 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933736AbaDIScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140409182553.GE10526@twins.programming.kicks-ass.net>
References: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
	<20140409182553.GE10526@twins.programming.kicks-ass.net>
Date: Wed, 9 Apr 2014 11:32:20 -0700
Message-ID: <CAF1ivSYeQcGf2d9kB-0R0TmCy=zaFg4WeJ2mgG_=K41hsoizyA@mail.gmail.com>
Subject: Re: current->sched_class->yield_task is NULL, any hint?
From: Lin Ming <minggr@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Apr 09, 2014 at 10:43:32AM -0700, Lin Ming wrote:
>> Hi Peter,
>>
>> I hit a panic in sys_sched_yield() because(for some unknown reason)
>> current->sched_class->yield_task is NULL.
>> It's an ARM embedded board with 3.4-rt kernel.
>>
>> Could you share any hint for the possible causes?
>
> What class does current->sched_class point to?

[12890.088232] Process swapper/0 (pid: 0, stack limit = 0xc07042f0)

It's idle task. I think it should be idle_sched_class.
But let me double check it.

Thanks.
