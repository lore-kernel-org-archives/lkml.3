Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3HVTmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:42:14 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:22780 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3HVTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:42:13 -0400
Message-ID: <1377200530.2710.2.camel@j-VirtualBox>
Subject: Re: [RFC PATCH v3] sched: Limit idle balance based on max cost per
 sched domain
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 Aug 2013 12:42:10 -0700
In-Reply-To: <20130822111027.GJ31370@twins.programming.kicks-ass.net>
References: <1376991166.1753.8.camel@j-VirtualBox>
	 <20130822111027.GJ31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 13:10 +0200, Peter Zijlstra wrote:
> Fully agreed, this is something we should do regardless -- for as long
> as we preserve the avg_idle() machinery anyway :-)

Okay, I'll have the avg_idle fix as part 1 of the v4 patchset.

> The thing you 'forgot' to mention is if this patch actually helps you
> workload?

Yes, this helps a lot of the workloads on the 8 socket machines. I will
be sure to include some numbers next time.

