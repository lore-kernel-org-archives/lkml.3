Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3GWPeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:34:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab3GWPeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:34:09 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=UUjx1oEZs6kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3Wd1iErDF5kA:10 a=CfR3sKC0JOukDLrJHCUA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374593646.3356.126.camel@gandalf.local.home>
Subject: Re: [PATCH v2 0/7] tracing: Kill the buggy trace_cpu
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 11:34:06 -0400
In-Reply-To: <20130723152531.GA23688@redhat.com>
References: <20130723152531.GA23688@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 17:25 +0200, Oleg Nesterov wrote:

> 	5/7: No changes. checkpatch.pl complains, but that
> 	     "line over 80 characters" in tracing_entries_read()
> 	     was not added by this patch and I do not know how
> 	     can I make checkpatch.pl happy without adding a
> 	     helper for per_cpu_ptr(tr->trace_buffer.data).

I take those as guidelines not rules. Especially if the fix to 80
characters is uglier than the original.

-- Steve


