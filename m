Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3JAOjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:39:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51210 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3JAOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:39:30 -0400
Date: Tue, 1 Oct 2013 16:39:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20131001143921.GO3657@laptop.programming.kicks-ass.net>
References: <20130930152242.207382649@infradead.org>
 <20130930174054.GA28129@redhat.com>
 <20130930180939.GN15690@laptop.programming.kicks-ass.net>
 <20130930181358.GA29544@redhat.com>
 <20131001140940.GA32328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001140940.GA32328@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 04:09:40PM +0200, Oleg Nesterov wrote:
> But somehow I didn't realize that ___wait_cond_timeout() can be used
> as is, so the simple patch below should work?

Yeah, should work.. But how often do people use timeout=0? Should we
really care about that case to the effect of adding more code.
