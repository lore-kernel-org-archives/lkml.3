Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaJHTCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:02:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:38999 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaJHTCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:02:49 -0400
Date: Wed, 8 Oct 2014 21:02:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
In-Reply-To: <20141008180814.GH4750@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1410082029020.4292@nanos>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org> <1411567455-31264-12-git-send-email-matt@console-pimps.org> <20141008180814.GH4750@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014, Peter Zijlstra wrote:
> On Wed, Sep 24, 2014 at 03:04:15PM +0100, Matt Fleming wrote:
> > +	preempt_disable();

< SNIP loooong code >

> > +	preempt_enable();
> 
> Why is all that under preempt_disable()?

To make life harder for people who care about latencies and
deterministic behaviour perhaps?

Thanks,

	tglx


