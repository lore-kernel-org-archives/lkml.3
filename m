Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3AKKOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:14:05 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33204 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3AKKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:14:03 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
In-Reply-To: <50EFCA29.8020801@linux.vnet.ibm.com>
References: <50EFCA29.8020801@linux.vnet.ibm.com>
User-Agent: Notmuch/0.14+104~g0a21fb9 (http://notmuchmail.org) Emacs/24.0.95.2 (x86_64-unknown-linux-gnu)
Date: Fri, 11 Jan 2013 15:43:47 +0530
Message-ID: <87hamo2fj8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011110-8256-0000-0000-000005C8943C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Michael Wang <wangyun@linux.vnet.ibm.com> writes:
> 	Prev:
> 		+---------+---------+-------+
> 		| 7484 MB |      32 | 42463 |
> 	Post:
> 		| 7483 MB |      32 | 44185 |		+0.18%
That should be +4.05%

Regards
Nikunj

