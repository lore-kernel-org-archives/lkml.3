Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3CSOCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:02:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54705
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab3CSOCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:02:33 -0400
Message-ID: <1363701741.22553.46.camel@laptop>
Subject: Re: [PATCH 2/8] sched: explicitly cpu_idle_type checking in
 rebalance_domains()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 15:02:21 +0100
In-Reply-To: <1360820921-2513-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> After commit 88b8dac0, dst-cpu can be changed in load_balance(),
> then we can't know cpu_idle_type of dst-cpu when load_balance()
> return positive. So, add explicit cpu_idle_type checking.

No real objection I suppose, but did you actually see this go wrong?


