Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3LSM2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:28:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49430 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3LSL6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:14 -0500
Date: Thu, 19 Dec 2013 12:57:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131219115759.GS3694@twins.programming.kicks-ass.net>
References: <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218133439.GR21999@twins.programming.kicks-ass.net>
 <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218141125.GT21999@twins.programming.kicks-ass.net>
 <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219112812.GY21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:28:12PM +0100, Peter Zijlstra wrote:
> This document you referred me to looks to specify something with a
> proper s/g implementation; called ToPA. There doesn't appear to be a
> limit to the linked entries and you can specify a size per entry, and I
> don't see anywhere why 4k would be bad.
> 
> That said, I'm still reading..

Found it:

"Single Output Region ToPA Implementation

The first processor generation to implement Intel PT supports only ToPA
configurations with a single ToPA entry followed by an END entry that
points back to the first entry (creating one circular output buffer).
Such processors enumerate CPUID.(EAX=14H,ECX=0):EBX[bit 1] as 0."

So basically you guys buggered the hardware.

More specifically, what actual hardware is this? Is this first
generation HSW or so?

Please enumerate the actual hardware that supports this PT stuff and
which hardware has it fixed.
