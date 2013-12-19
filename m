Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3LSOtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:49:47 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:62171 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3LSOtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:49:45 -0500
Date: Thu, 19 Dec 2013 15:49:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131219144926.GB19788@localhost.localdomain>
References: <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218141125.GT21999@twins.programming.kicks-ass.net>
 <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:30:53PM +0200, Alexander Shishkin wrote:
> Or the interface and implementation of BTS support in the kernel
> discourage its use and that is why it is so rarely used.

I never heard complains about it. It's a simple dump of from/to address couples.
I just think nobody take the time to develop userspace tooling to exploit it.
But it's famous slowness might have had a bad influence on this. And may be
also the fact that it's very architecture specific. AMD doesn't support BTS if I recall
correctly. Or may be it has its own different implementation?
