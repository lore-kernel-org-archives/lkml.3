Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaKDMIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:08:41 -0500
Received: from mail113-251.mail.alibaba.com ([205.204.113.251]:41778 "EHLO
	us-alimail-mta1.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753913AbaKDMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:08:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03043;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=8;RT=8;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Vincent Guittot'" <vincent.guittot@linaro.org>
Cc: "'Wanpeng Li'" <kernellwp@gmail.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Preeti U Murthy'" <preeti@linux.vnet.ibm.com>,
        "'Morten Rasmussen'" <Morten.Rasmussen@arm.com>,
        "'Kamalesh Babulal'" <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
Date: Tue, 04 Nov 2014 20:07:44 +0800
Message-ID: <011001cff827$f14b9870$d3e2c950$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac/4JKLZrobawMGFRYuFjk4tF8JOtA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>   +     /*
> >> +        * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
> >
> >
> > Why specify one task instead of not less than one?
> 
> if cfs.h_nr_running = 0 (which should not occurs at that point), we
> don't need to do more test to check if it's worth moving the task
> because there is no task to move.
> 
I wonder if you can please shed light on the case that 
the dst_cpu is newly idle.

Thanks
Hillf

