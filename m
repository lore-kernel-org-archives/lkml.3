Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3EXN0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32116 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3EXN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:26:29 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=WMSQmTvSkQgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=q2K0fnxkuFAA:10 a=VnNF1IyMAAAA:8 a=E6g8GtUs94lhwNQ-Q9MA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369401986.6828.221.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: code cleanup
From: Steven Rostedt <rostedt@goodmis.org>
To: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com
Date: Fri, 24 May 2013 09:26:26 -0400
In-Reply-To: <1369380137-12452-1-git-send-email-harsh@linux.vnet.ibm.com>
References: <1369380137-12452-1-git-send-email-harsh@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-24 at 12:52 +0530, Harsh Prateek Bora wrote:
> Signed-off-by: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_events.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 7a0cf68..371c7b0 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -2011,10 +2011,7 @@ event_enable_func(struct ftrace_hash *hash,
>  	int ret;
>  
>  	/* hash funcs only work with set_ftrace_filter */
> -	if (!enabled)
> -		return -EINVAL;
> -
> -	if (!param)
> +	if (!enabled || !param)
>  		return -EINVAL;
>  
>  	system = strsep(&param, ":");


Thanks, I added it to my 3.11 queue.

-- Steve


