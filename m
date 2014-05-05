Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaEEPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:16:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:55954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaEEPQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:16:27 -0400
Date: Mon, 5 May 2014 17:16:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing: Remove myself as a tracing maintainer
Message-ID: <20140505151620.GS26782@laptop.programming.kicks-ass.net>
References: <1399131991-13216-1-git-send-email-fweisbec@gmail.com>
 <20140505111301.65497e33@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505111301.65497e33@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:13:01AM -0400, Steven Rostedt wrote:
> Thanks for all the tracing work! Although, I believe Peter Zijlstra has
> some frozen sharks heading your way. ;-)

Ah yes.. syscall tracing.. the syscall numbers are decimal, the syscall
return value is decimal, but the syscall arguments are hex (without a
0x) prefix.

Confused me properly for a while.
