Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab3KMOuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:50:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3KMOuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:50:20 -0500
Date: Wed, 13 Nov 2013 15:50:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] state/exit_state cleanups (Was: Remove unused
 variable ret from sync_thread_master())
Message-ID: <20131113145001.GD10977@twins.programming.kicks-ass.net>
References: <20131113143552.GA10517@redhat.com>
 <20131113144856.GL26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113144856.GL26898@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:48:56PM +0100, Peter Zijlstra wrote:
> For these patches:
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>

On that, I'll just pick them up and stuff them through the scheduler
tree, its mostly sched related anyway.
