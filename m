Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3F0UiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:38:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3F0UiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:38:17 -0400
Date: Thu, 27 Jun 2013 22:37:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130627203733.GC29209@dyad.programming.kicks-ass.net>
References: <51CA0622.8010105@gmail.com>
 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
 <51CA0980.8010409@gmail.com>
 <20130626070533.GA3601@dyad.programming.kicks-ass.net>
 <51CB1AE9.5090709@gmail.com>
 <20130627104309.GQ28407@twins.programming.kicks-ass.net>
 <20130627105303.GD27378@dyad.programming.kicks-ass.net>
 <51CC8FEC.8030605@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CC8FEC.8030605@mit.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:18:04PM -0700, Andy Lutomirski wrote:
> Supposedly, on really new x86 systems, the TSC deadline timer is so fast
> to reprogram that this isn't worth it.

>From what I've heard its not all that fast. I should play with it sometime, my
SNB desktop actually has this thing.
