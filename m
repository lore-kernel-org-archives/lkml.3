Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3GBXjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:39:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22976 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3GBXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:39:53 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=gRE7txOSQBgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zYSyO7zkCp0A:10 a=i0EeH86SAAAA:8 a=RHthe3nIL10Pa05Di_8A:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372808392.22688.83.camel@gandalf.local.home>
Subject: Re: [PATCH v3 07/12] tracing: remove TRACE_EVENT_TYPE enum
 definition
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 19:39:52 -0400
In-Reply-To: <1365564393-10972-8-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
	 <1365564393-10972-8-git-send-email-jovi.zhangwei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> 
> TRACE_EVENT_TYPE enum is not used at present, remove it.

Looks reasonable, pulled.

Thanks,

-- Steve

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace.h |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 89da073..9964695 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -794,12 +794,6 @@ static inline void trace_branch_disable(void)
>  /* set ring buffers to default size if not already done so */
>  int tracing_update_buffers(void);
>  
> -/* trace event type bit fields, not numeric */
> -enum {
> -	TRACE_EVENT_TYPE_PRINTF		= 1,
> -	TRACE_EVENT_TYPE_RAW		= 2,
> -};
> -
>  struct event_filter {
>  	int			n_preds;	/* Number assigned */
>  	int			a_preds;	/* allocated */


