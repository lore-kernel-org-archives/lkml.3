Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309AbaH1Heb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:34:31 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:54211 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936184AbaH1Hea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140827133033.GC13808@linux.vnet.ibm.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org> <20140827133033.GC13808@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 28 Aug 2014 09:34:09 +0200
Message-ID: <CAKfTPtAkT9yk4jLP_W9LNeqP_=Ycyda6vgk2YrnCuq6+=Y_UGA@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] sched: add per rq cpu_capacity_orig
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2014 15:32, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> * Vincent Guittot <vincent.guittot@linaro.org> [2014-08-26 13:06:49]:
>
>> This new field cpu_capacity_orig reflects the available capacity of a CPUs
>> unlike the cpu_capacity which reflects the current capacity that can be altered
>> by frequency and rt tasks.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks

>
