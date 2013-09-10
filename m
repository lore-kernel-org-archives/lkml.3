Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3IJCuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:50:52 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:33666 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3IJCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130909111508.GO31370@twins.programming.kicks-ass.net>
References: <CALZhoST+i8TOfQtu-z-bFrwmAVERZ6gHO1k_M_J24se8Hq_qyw@mail.gmail.com>
	<20130909111508.GO31370@twins.programming.kicks-ass.net>
Date: Tue, 10 Sep 2013 10:50:49 +0800
Message-ID: <CALZhoSQrJ7aLkzkDxwd4diSXUUG3tJ7qpzpy7N6XEpW21NxAvg@mail.gmail.com>
Subject: Re: Question regarding list_for_each_entry_safe usage in move_one_task
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, leiwen@marvell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 7:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Sep 02, 2013 at 02:26:45PM +0800, Lei Wen wrote:
>> Hi Peter,
>>
>> I find one list API usage may not be correct in current fair.c code.
>> In move_one_task function, it may iterate through whole cfs_tasks
>> list to get one task to move.
>>
>> But in dequeue_task(), it would delete one task node from list
>> without the lock protection. So that we could see from
>> list_for_each_entry_safe API definitoin:
>
> Both sites hold the required rq->lock.

I see, sorry for the noise...

Thanks,
Lei
