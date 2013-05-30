Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968044Ab3E3JUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:20:47 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:49644 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967942Ab3E3JUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
References: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
Date: Thu, 30 May 2013 11:20:38 +0200
Message-ID: <CAFTL4hyk2krdKFQ1rp7ik9ezMPor9i1j3DNJfuMgnL=prP7w+w@mail.gmail.com>
Subject: Re: [PATCH -tip] sched/fair: Remove unused variable from expire_cfs_rq_runtime()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/30 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>:
> 78becc2709 "sched: Use an accessor to read the rq clock"
> introduces rq_clock(), which obsoletes use of "rq" in
> expire_cfs_rq_runtime() and triggers build warning:
>
> kernel/sched/fair.c: In function 'expire_cfs_rq_runtime':
> kernel/sched/fair.c:2159:13: warning: unused variable 'rq' [-Wunused-variable]
>
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
