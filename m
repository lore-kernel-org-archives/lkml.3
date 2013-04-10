Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936905Ab3DJPIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:08:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab3DJPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:08:18 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hagb512zhIEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=nmCG74HkNA8A:10 a=i0EeH86SAAAA:8 a=1O1MUW1pnHYxsumj4wcA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365606496.9609.13.camel@gandalf.local.home>
Subject: Re: [PATCH v3 00/12] event tracing expose change and bugfix/cleanup
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 11:08:16 -0400
In-Reply-To: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> 
> Hi steven,
> 
> I have reworked this patchset again with minor change.
> [v2 -> v3:
> -   change trace_descripte_t defintion in patch 3
> -   new patch "export ftrace_events"
> -   remove patch "export syscall metadata"
>     (syscall tracing are use same event_trace_ops backend as normal event tracepoint,
>      so there's no need to export anything of syscall)
> -   remove private data field in ftrace_event_file struct (also not needed)
> ]

Thanks,

Note, I'm trying to catch up on my -rt responsibilities, and most likely
wont get to this this week, and next week I'll be at collaboration
summit. It may not be till after I get back from that, that I'll have a
chance to look at these.

Depending on when Linus opens the next merge window, even if everything
goes fine, this patch set may not make it into 3.10, and will have to
wait till 3.11.

Just giving you a heads up.

-- Steve


