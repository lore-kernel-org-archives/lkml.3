Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3KOKJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:09:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3KOKI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:08:56 -0500
Date: Fri, 15 Nov 2013 11:08:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RESEND] sched/fair: simple cleanup in update_sg_lb_stats()
Message-ID: <20131115100852.GF2965@twins.programming.kicks-ass.net>
References: <1384508212-25032-1-git-send-email-kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384508212-25032-1-git-send-email-kamalesh@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:06:52PM +0530, Kamalesh Babulal wrote:
> Add rq->nr_running to sgs->sum_nr_running directly instead of
> assigning it through an intermediate variable nr_running.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks!
