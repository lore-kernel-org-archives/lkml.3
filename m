Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbaEMI0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:26:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaEMI0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:26:17 -0400
Date: Tue, 13 May 2014 10:26:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, jet.chen@intel.com, fengguang.wu@intel.com,
        linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sched: fix: initialization of sched_domain_topology for NUMA
Message-ID: <20140513082609.GA2485@laptop.programming.kicks-ass.net>
References: <1399929376-4597-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399929376-4597-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:16:16PM +0200, Vincent Guittot wrote:
> sched_domain_topology table is a null terminated array. 
> Add 1 row in the allocation size that will be used as the last row of the
> table.
> 
> Reported-by: Jet Chen <jet.chen@intel.com>
> Tested-by: Jet Chen <jet.chen@intel.com>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> link: https://lkml.org/lkml/2014/5/12/130
> 
> ---
> 
> Hi Ingo and Peter,
> 
> This patch fixes the problem that has been reported by Jet Chen 
> 

I have no mail from Jet Chen on any recent issues.

Also, please describe both the problem and the fix in the Changelog
without need to refer to secondary sources.

As it stands I've no clue wth this is about.
