Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3BADsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:48:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3BADso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:48:44 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zzhEZVgmVRcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=QEcsOeN0EBIA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=P1msPjNgVdi2DOwNq3AA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359690521.5642.10.camel@gandalf.local.home>
Subject: Re: [PATCH 3/4] Export blk_fill_rwbs()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kent Overstreet <koverstreet@google.com>, Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 31 Jan 2013 22:48:41 -0500
In-Reply-To: <1358285142-10576-3-git-send-email-koverstreet@google.com>
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>
	 <1358285142-10576-3-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li,

Can you give an Ack or Nack for this.

Thanks,

-- Steve


On Tue, 2013-01-15 at 13:25 -0800, Kent Overstreet wrote:
> Exported so it can be used by bcache's tracepoints
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/blktrace.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index c0bd030..dbe1667 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1806,6 +1806,7 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
>  
>  	rwbs[i] = '\0';
>  }
> +EXPORT_SYMBOL_GPL(blk_fill_rwbs);
>  
>  #endif /* CONFIG_EVENT_TRACING */
>  


