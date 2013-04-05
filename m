Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161940Ab3DEPFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161917Ab3DEPFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:05:13 -0400
Date: Fri, 5 Apr 2013 17:01:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless
	local_save_flags/preempt_count calls
Message-ID: <20130405150110.GA31300@redhat.com>
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515E4938.6090809@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Masami Hiramatsu wrote:
>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

Masami, perhaps you can also answer the question I asked in 0/4
marc.info/?l=linux-kernel&m=136458107403835 ?

	Off-topic question... Why uprobe_perf_func() passes "addr = ip" to
	perf_trace_buf_submit() ? This just sets perf_sample_data->addr for
	PERF_SAMPLE_ADDR, do we really need this? and we already have
	perf_sample_data->ip initialized by perf.

kprobe_perf_func() and kretprobe_perf_func() do the same.

Once again, I am just curious and this is completely offtopic.

Oleg.

