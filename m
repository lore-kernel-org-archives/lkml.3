Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLCJGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:06:36 -0500
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:42783 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751843AbaLCJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:06:25 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2731:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:4385:5007:6119:6261:7875:8603:9010:10004:10400:10848:10967:11026:11232:11658:11914:12043:12517:12519:12555:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pain74_54f36ddedde5c
X-Filterd-Recvd-Size: 2138
Date: Wed, 3 Dec 2014 04:06:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: describe trace_buf_size parameter more
 accurately
Message-ID: <20141203040620.254a8a02@gandalf.local.home>
In-Reply-To: <1417570760-10620-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1417570760-10620-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Dec 2014 10:39:20 +0900
Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> I'm stuck into panic that too litte free memory is left when I boot with
> trace_buf_size parameter. After digging into the problem, I found that
> trace_buf_size is the size of trace buffer on each cpu rather than total
> size of trace buffer. To prevent victim like me, change description of
> trace_buf_size parameter more accurately.

Heh, Thanks, I'll apply this.

-- Steve

> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  Documentation/kernel-parameters.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 70cfce5..fc77457 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3546,7 +3546,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			are saved.
>  
>  	trace_buf_size=nn[KMG]
> -			[FTRACE] will set tracing buffer size.
> +			[FTRACE] will set tracing buffer size on each cpu.
>  
>  	trace_event=[event-list]
>  			[FTRACE] Set and start specified trace events in order

