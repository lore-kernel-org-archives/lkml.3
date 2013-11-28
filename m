Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3K1C5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:57:55 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:64270 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab3K1C5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:57:53 -0500
Date: Wed, 27 Nov 2013 18:57:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched:  Check sched_domain before computing
 group power
In-Reply-To: <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1311271857180.5120@chino.kir.corp.google.com>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net> <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, tip-bot for Srikar Dronamraju wrote:

> Commit-ID:  9abf24d465180f5f2eb26a43545348262f16b771
> Gitweb:     http://git.kernel.org/tip/9abf24d465180f5f2eb26a43545348262f16b771
> Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> AuthorDate: Tue, 12 Nov 2013 22:11:26 +0530
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 19 Nov 2013 17:01:15 +0100
> 
> sched: Check sched_domain before computing group power
> 
> After commit 863bffc80898 ("sched/fair: Fix group power_orig
> computation"), we can dereference rq->sd before it is set.
> 
> Fix this by falling back to power_of() in this case and add a comment
> explaining things.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> [ Added comment and tweaked patch. ]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: mikey@neuling.org
> Link: http://lkml.kernel.org/r/20131113151718.GN21461@twins.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

Fixes a boot failure for me, thanks.
