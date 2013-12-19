Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3LSPKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:10:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55044 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3LSPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:10:32 -0500
Date: Thu, 19 Dec 2013 16:10:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131219151024.GI16438@laptop.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:30:53PM +0200, Alexander Shishkin wrote:
> So I'd like to steer away from the ways in which hardware can be broken
> and talk about a usable interface, to begin with.

Just dump it into the regular one buffer like I outlined.

That said; we very much need to have at least two architectures
implemented for any of this code to move.

But we cannot ignore the hardware trainwreck; we cannot shape our
interface around something that's utterly broken.

Some hardware is just too broken to support.
