Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3LPOpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:45:34 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21624 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3LPOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:45:32 -0500
Message-ID: <1387205130.2797.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/3] perf-bench: add futex-wake microbenchmark
From: Davidlohr Bueso <davidlohr@hp.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        dvhart@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
        jason.low2@hp.com, Waiman.Long@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Mon, 16 Dec 2013 06:45:30 -0800
In-Reply-To: <87k3f5gyet.fsf@sejong.aot.lge.com>
References: <1387081917-9102-1-git-send-email-davidlohr@hp.com>
	 <1387081917-9102-3-git-send-email-davidlohr@hp.com>
	 <87k3f5gyet.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 14:25 +0900, Namhyung Kim wrote:
> Hi Davidlohr,
> 
> On Sat, 14 Dec 2013 20:31:56 -0800, Davidlohr Bueso wrote:
> > Block a bunch of threads on a futex and wake them up, N at a time.
> >
> > This program is particularly useful to measure the latency of nthread wakeups
> > in non-error situations:  all waiters are queued and all wake calls wakeup
> > one or more tasks. An example run:
> >
> > $ perf bench futex -t 512 -r 100
> 
> Did you mean 'perf bench futex wake'?

Yes I did.

Thanks,
Davidlohr

