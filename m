Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3EaP7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:59:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44069 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EaP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:59:00 -0400
Date: Fri, 31 May 2013 17:58:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@kernel.org
Subject: Re: [PATCH -tip] sched/fair: Remove unused variable from
 expire_cfs_rq_runtime()
Message-ID: <20130531155853.GA5910@twins.programming.kicks-ass.net>
References: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:34:20PM +0530, Kamalesh Babulal wrote:
> 78becc2709 "sched: Use an accessor to read the rq clock"
> introduces rq_clock(), which obsoletes use of "rq" in
> expire_cfs_rq_runtime() and triggers build warning:
> 
> kernel/sched/fair.c: In function 'expire_cfs_rq_runtime':
> kernel/sched/fair.c:2159:13: warning: unused variable 'rq' [-Wunused-variable]
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks!
