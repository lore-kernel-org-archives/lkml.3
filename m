Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3FELQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:16:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3FELQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:16:11 -0400
Date: Wed, 5 Jun 2013 13:16:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] sched: remove the useless declaration in
 kernel/sched/fair.c
Message-ID: <20130605111605.GB8923@twins.programming.kicks-ass.net>
References: <51AD87A8.6080608@linux.vnet.ibm.com>
 <51AD8808.7020608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD8808.7020608@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:24:08PM +0800, Michael Wang wrote:
> default_cfs_period(), do_sched_cfs_period_timer(), do_sched_cfs_slack_timer()
> already defined previously, no need to declare again.
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Thanks!
