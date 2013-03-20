Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3CTGrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:47:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52088 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3CTGrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:47:40 -0400
X-AuditID: 9c93016f-b7cecae000004cf8-ce-51495b8a4be3
Date: Wed, 20 Mar 2013 15:48:03 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] sched: explicitly cpu_idle_type checking in
 rebalance_domains()
Message-ID: <20130320064803.GA11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1360820921-2513-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1363701741.22553.46.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363701741.22553.46.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Tue, Mar 19, 2013 at 03:02:21PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > After commit 88b8dac0, dst-cpu can be changed in load_balance(),
> > then we can't know cpu_idle_type of dst-cpu when load_balance()
> > return positive. So, add explicit cpu_idle_type checking.
> 
> No real objection I suppose, but did you actually see this go wrong?

No, I found it while I review whole scheduler code.
Thanks.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
