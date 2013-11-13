Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3KMP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:58:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3KMP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:58:38 -0500
Date: Wed, 13 Nov 2013 16:58:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] sched: Check TASK_DEAD rather than EXIT_DEAD in
 schedule_debug()
Message-ID: <20131113155820.GP21461@twins.programming.kicks-ass.net>
References: <20131113143552.GA10517@redhat.com>
 <20131113144856.GL26898@twins.programming.kicks-ass.net>
 <20131113154516.GA15810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113154516.GA15810@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 04:45:16PM +0100, Oleg Nesterov wrote:
> Thanks! And since picked this series, perhaps you can also queue this
> one?

Done; if there's something fishy we're bound to hit it before .14 (I
hope).
