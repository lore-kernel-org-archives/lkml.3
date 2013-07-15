Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3GOQ23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:28:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab3GOQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:28:28 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=TCvBf9P_FREA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=aUkMh35ueQYA:10 a=zW1UpoXLWwo_Rl7pwmMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373905707.17876.151.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing: some minor fix
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Jul 2013 12:28:27 -0400
In-Reply-To: <51E3B396.8030905@huawei.com>
References: <51E3B396.8030905@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 16:32 +0800, zhangwei(Jovi) wrote:
> Hi Steven,
> 
> This patchset don't have big change on tracing, just three minor fix,
> please check it.

Thanks, they seem fine. I'll add them to my queue.

-- Steve

> 
> Thanks.
> 
> zhangwei(Jovi) (3):
>   tracing: use correct config guard CONFIG_STACK_TRACER
>   tracing: use trace_seq_puts()/trace_seq_putc() where possible
>   tracing: update typo of ring buffer comments
> 
>  kernel/trace/ring_buffer.c           |   26 +++++++++--------
>  kernel/trace/trace.c                 |    4 +--
>  kernel/trace/trace_events_filter.c   |    4 +--
>  kernel/trace/trace_functions_graph.c |   52 +++++++++++++++++-----------------
>  kernel/trace/trace_mmiotrace.c       |    8 +++---
>  kernel/trace/trace_output.c          |   14 ++++-----
>  kernel/trace/trace_syscalls.c        |    2 +-
>  7 files changed, 56 insertions(+), 54 deletions(-)
> 


