Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3E3OCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:02:07 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45644 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3E3OB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:01:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hyk2krdKFQ1rp7ik9ezMPor9i1j3DNJfuMgnL=prP7w+w@mail.gmail.com>
References: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com> <CAFTL4hyk2krdKFQ1rp7ik9ezMPor9i1j3DNJfuMgnL=prP7w+w@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 30 May 2013 07:01:27 -0700
Message-ID: <CAPM31RLf134BzcuJq+0CkRMA__cbVEO8qp5kVDyjhNq+xJEmYg@mail.gmail.com>
Subject: Re: [PATCH -tip] sched/fair: Remove unused variable from expire_cfs_rq_runtime()
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good

On Thu, May 30, 2013 at 2:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/5/30 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>:
>> 78becc2709 "sched: Use an accessor to read the rq clock"
>> introduces rq_clock(), which obsoletes use of "rq" in
>> expire_cfs_rq_runtime() and triggers build warning:
>>
>> kernel/sched/fair.c: In function 'expire_cfs_rq_runtime':
>> kernel/sched/fair.c:2159:13: warning: unused variable 'rq' [-Wunused-variable]
>>
>> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>
> Thanks!
>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
