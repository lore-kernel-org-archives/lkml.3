Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647Ab3LIGdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:33:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:58069 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760621Ab3LIGdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:33:15 -0500
Message-ID: <1386570586.5159.43.camel@pasglop>
Subject: Re: [PATCH] sched: Remove PREEMPT_NEED_RESCHED from generic code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Graf <agraf@suse.de>
Date: Mon, 09 Dec 2013 17:29:46 +1100
In-Reply-To: <20131128132641.GP10022@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
	 <20131128132641.GP10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 14:26 +0100, Peter Zijlstra wrote:
> Subject: sched: Remove PREEMPT_NEED_RESCHED from generic code
> 
> While hunting a preemption issue with Alexander, Ben noticed that the
> currently generic PREEMPT_NEED_RESCHED stuff is horribly broken for
> load-store architectures.

Hi Peter !

Are you sending this to Linus ? From what I can tell the bug is still
upstream ...

Cheers,
Ben.


