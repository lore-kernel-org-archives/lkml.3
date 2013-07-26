Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab3GZOXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:23:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994Ab3GZOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:23:30 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DwtdHThkOYoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=D1LXhyGZXAkA:10 a=i0EeH86SAAAA:8 a=UpWnXQfAW7c4NQLsXxAA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374848608.6580.28.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2][RESEND] tracing/syscalls: Annotate raw_init
 function with __init
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Jul 2013 10:23:28 -0400
In-Reply-To: <51F08D1B.1080300@huawei.com>
References: <51F08D1B.1080300@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 10:27 +0800, Li Zefan wrote:
> init_syscall_trace() can be called during kernel bootup only, so we can
> mark it and the functions it calls as __init.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
> 
> this was sent 4 months ago.
> 

And it was still in my todo list :-/

Sorry, it was lost in the noise, as there's lots in my todo list, and
things that are marked for cleanup got pushed to the bottom.

I'll add this to my 3.12 queue.

Thanks!

-- Steve


