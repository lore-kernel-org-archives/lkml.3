Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3LSPCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:02:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3LSPCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:02:43 -0500
Date: Thu, 19 Dec 2013 16:02:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131219150226.GH16438@laptop.programming.kicks-ass.net>
References: <20131218141125.GT21999@twins.programming.kicks-ass.net>
 <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219144926.GB19788@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219144926.GB19788@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 03:49:42PM +0100, Frederic Weisbecker wrote:
> On Thu, Dec 19, 2013 at 04:30:53PM +0200, Alexander Shishkin wrote:
> > Or the interface and implementation of BTS support in the kernel
> > discourage its use and that is why it is so rarely used.
> 
> I never heard complains about it. It's a simple dump of from/to address couples.
> I just think nobody take the time to develop userspace tooling to exploit it.
> But it's famous slowness might have had a bad influence on this. And may be
> also the fact that it's very architecture specific. AMD doesn't support BTS if I recall
> correctly. Or may be it has its own different implementation?

No AMD doesn't do anything like that.

There was some attempt to cure some of the wobblies:

  https://lkml.org/lkml/2013/7/8/154

But people never pursued that.

That said, if people want overwrite mode to work for PT we'd need to fix
the same thing.
