Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaAFWQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:16:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaAFWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:16:00 -0500
Date: Mon, 6 Jan 2014 23:15:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20140106221528.GK30183@twins.programming.kicks-ass.net>
References: <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iotw6bwx.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think the PT design is broken in any way, it's straight 
> forward and simple.

Also, do clarify the other points I asked about. Esp. the non
FREEZE_ON_PMI behaviour of the PT PMI is worrying me immensely.

To me it seems very weird that PT is hooked to the same PMI as the
normal PMU, it really should have been a different interrupt.
