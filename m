Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3FELQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:16:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3FELQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:16:44 -0400
Date: Wed, 5 Jun 2013 13:16:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: mingo@redhat.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH] sched: Rename sched.c as sched/core.c in comments and
 Documentation
Message-ID: <20130605111637.GC8923@twins.programming.kicks-ass.net>
References: <cdff76a265326ab8d71922a1db5be599f20aad45.1370329560.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdff76a265326ab8d71922a1db5be599f20aad45.1370329560.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 01:10:24PM +0530, Viresh Kumar wrote:
> Most of the stuff from kernel/sched.c was moved to kernel/sched/core.c long time
> back and the comments/Documentation never got updated.
> 
> I figured it out when I was going through sched-domains.txt and so thought of
> fixing it globally.
> 
> I haven't crossed check if the stuff that is referenced in sched/core.c by all
> these files is still present and hasn't changed as that wasn't the motive behind
> this patch.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks!
