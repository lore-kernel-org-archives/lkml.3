Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaKLLpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:45:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:43494 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaKLLpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:45:45 -0500
Date: Wed, 12 Nov 2014 12:45:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112114538.GJ10476@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112113737.GI10476@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112113737.GI10476@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 12:37:37PM +0100, Peter Zijlstra wrote:

> Which would make the sample run ahead, making the sleep short. So would
> something like the below not cure things?

Before anyone asks, yes I tried running that 'reproducer' it doesn't.
