Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3CBDR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:17:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CBDR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:17:27 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9L-SzeXpsv8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=YxhCV0W8IeoA:10 a=QyXUC8HyAAAA:8 a=i0EeH86SAAAA:8 a=LCoiq5OKWpDlZ0wJITEA:9 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362194245.1231.71.camel@gandalf.local.home>
Subject: Re: [PATCH 1/4] tracing/syscalls: Anotate some functions static
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 22:17:25 -0500
In-Reply-To: <51258723.2040301@huawei.com>
References: <51258723.2040301@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been fixed already in mainline:

commit 6aea49cb5f3001a8275bf9c9f586ec3eb39af194
tracing/syscalls: Make local functions static
Author: Fengguang Wu <fengguang.wu@intel.com>

-- Steve


On Thu, 2013-02-21 at 10:32 +0800, Li Zefan wrote:
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/trace/trace_syscalls.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 7609dd6..5329e13 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -77,7 +77,7 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
>  	return syscalls_metadata[nr];
>  }
>  
> -enum print_line_t
> +static enum print_line_t
>  print_syscall_enter(struct trace_iterator *iter, int flags,
>  		    struct trace_event *event)
>  {
> @@ -130,7 +130,7 @@ end:
>  	return TRACE_TYPE_HANDLED;
>  }
>  


