Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3HESIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:08:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3HESIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:08:12 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0AJcHNpvdqsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Sa1Rl5lfkWwA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=l9Kmty0bS_9SzfG4WXIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375726091.22073.106.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] tracing/perf: Expand TRACE_EVENT(sched_stat_runtime)
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 14:08:11 -0400
In-Reply-To: <20130805165056.GA6366@redhat.com>
References: <20130805165056.GA6366@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 18:50 +0200, Oleg Nesterov wrote:

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Tested-by: David Ahern <dsahern@gmail.com>
> Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>

Just so you know. The standard that we now want to live by is only one
tag per line. I know I gave you that tag in my email, but when adding it
to a patch it needs to be:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>

I wonder if the Reviewed-by assumes the Acked-by? Anyway, if you add
both, it needs to be like that.

-- Steve


