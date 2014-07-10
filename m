Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaGJSBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:01:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42783 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751361AbaGJSBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:01:35 -0400
Date: Thu, 10 Jul 2014 14:01:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 04/21] ftrace: Optimize function graph to be
 called directly
Message-ID: <20140710140125.0f585a84@gandalf.local.home>
In-Reply-To: <53BED155.9040607@nvidia.com>
References: <20140703160503.006976702@goodmis.org>
	<20140703161224.062459692@goodmis.org>
	<53BED155.9040607@nvidia.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 20:45:57 +0300
Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:


> This commit (79922b8) breaks the function graph tracer on today's -next. 
> This is on an ARM Tegra board.
> 
> I'm using ftrace with this script:
> 
> #!/bin/sh
> echo function_graph > /d/tracing/current_tracer
> echo clear > /d/tracing/trace
> echo $$ > /d/tracing/set_ftrace_pid
> exec "$@"
> 
> ...and a simple './trace.sh ls' crashes with no console output. SysRq is 
> not responsive either.

Thanks for the report. I'll boot up one of my arm boards and see if I
can reproduce it. I'll try to get to it either this week or next.

-- Steve

