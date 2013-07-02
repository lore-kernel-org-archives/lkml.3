Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3GBXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:16:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GBXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:16:27 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=hagb512zhIEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=nmCG74HkNA8A:10 a=i0EeH86SAAAA:8 a=Kg2J0U58kaBxNp7LJ_8A:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372806986.22688.75.camel@gandalf.local.home>
Subject: Re: [PATCH v3 00/12] event tracing expose change and bugfix/cleanup
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 19:16:26 -0400
In-Reply-To: <1365606496.9609.13.camel@gandalf.local.home>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
	 <1365606496.9609.13.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:08 -0400, Steven Rostedt wrote:
> On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
> > From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> > 
> > Hi steven,
> > 
> > I have reworked this patchset again with minor change.
> > [v2 -> v3:
> > -   change trace_descripte_t defintion in patch 3
> > -   new patch "export ftrace_events"
> > -   remove patch "export syscall metadata"
> >     (syscall tracing are use same event_trace_ops backend as normal event tracepoint,
> >      so there's no need to export anything of syscall)
> > -   remove private data field in ftrace_event_file struct (also not needed)
> > ]
> 
> Thanks,
> 
> Note, I'm trying to catch up on my -rt responsibilities, and most likely
> wont get to this this week, and next week I'll be at collaboration
> summit. It may not be till after I get back from that, that I'll have a
> chance to look at these.
> 
> Depending on when Linus opens the next merge window, even if everything
> goes fine, this patch set may not make it into 3.10, and will have to
> wait till 3.11.

Sorry, I've been buried in other work and going through my TODO list in
my inbox I've stumbled on this. If anything, it will have to wait for
3.12, but I have some questions about this patch set that needs to be
answered first. I'll reply to individual patches.

-- Steve


