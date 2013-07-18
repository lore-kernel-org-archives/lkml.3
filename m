Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3GRJm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:42:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58263 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GRJmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:42:55 -0400
Date: Thu, 18 Jul 2013 11:42:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
Message-ID: <20130718094237.GI27075@twins.programming.kicks-ass.net>
References: <20130617170142.GA19780@redhat.com>
 <1374116446.6458.203.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374116446.6458.203.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:00:46PM -0400, Steven Rostedt wrote:
> Peter,
> 
> These have been discussed, and they mostly live in the tracing
> directory, but are perf related. Can you give me your Acked-by on them.

I haven't looked in detail, but I trust Oleg. The only thing I can
remember is that I objected to the changelogs in that it wasn't at all
clear why we were doing these patches (Oleg did clarify in a separate
email, not sure the changelogs were ammended).

Other than that sure, go ahead.
