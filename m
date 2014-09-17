Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaIQQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:12:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:54495 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755608AbaIQQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:12:45 -0400
Date: Wed, 17 Sep 2014 12:12:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 02/41] tracing: Replace __get_cpu_var uses with
 this_cpu_ptr
Message-ID: <20140917121235.2de4ea19@gandalf.local.home>
In-Reply-To: <20140826175955.GB31659@mtj.dyndns.org>
References: <20131203233232.928771708@linux.com>
	<20131203233245.938331714@linux.com>
	<20140826175955.GB31659@mtj.dyndns.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 13:59:55 -0400
Tejun Heo <tj@kernel.org> wrote:

> On Tue, Dec 03, 2013 at 05:32:34PM -0600, Christoph Lameter wrote:
> > Replace uses of &__get_cpu_var for address calculation with this_cpu_ptr.
> > 
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Ingo Molnar <mingo@redhat.com>
> > Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
> patch should be routed differently.  Note that this patch was to be
> applied to percpu/for-3.17 but delayed due to build issues caused by
> cpumask_var_t.
> 

Sorry for the late reply, had other issues to attend to.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
