Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3DAFKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:10:35 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55295 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3DAFKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:10:34 -0400
X-AuditID: 9c930197-b7c9dae000006959-49-515916c7614b
Date: Mon, 1 Apr 2013 14:10:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
Message-ID: <20130401051042.GC12015@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1364557514.5053.85.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364557514.5053.85.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Mar 29, 2013 at 12:45:14PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-03-28 at 16:58 +0900, Joonsoo Kim wrote:
> > There is not enough reason to place this checking at
> > update_sg_lb_stats(),
> > except saving one iteration for sched_group_cpus. But with this
> > change,
> > we can save two memset cost and can expect better compiler
> > optimization,
> > so clean-up may be more beneficial to us.
> 
> It would be good if you'd described what you actually did, there's a
> lot of code movement and now I have to figure out wth you did and why.

Okay. I will do that when respin.

Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
