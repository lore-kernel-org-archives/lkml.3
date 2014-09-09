Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaIIWUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:20:19 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:40632 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752099AbaIIWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:20:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1568:1593:1594:1711:1714:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:3872:3873:3874:4250:4321:4605:5007:7652:7903:9040:9149:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vest84_1f4ec42a7595a
X-Filterd-Recvd-Size: 2046
Message-ID: <1410301213.22675.4.camel@joe-AO725>
Subject: Re: [PATCH] tracing: fix typo in pr_warning() message
From: Joe Perches <joe@perches.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Sep 2014 15:20:13 -0700
In-Reply-To: <1410299369-20029-1-git-send-email-luis.henriques@canonical.com>
References: <1410299369-20029-1-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 22:49 +0100, Luis Henriques wrote:
> Replace 'produciton' by 'production'
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8a528392b1f4..f3ef80c8914c 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2028,7 +2028,7 @@ void trace_printk_init_buffers(void)
>  	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
>  	pr_warning("**                                                      **\n");
>  	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
> -	pr_warning("** unsafe for produciton use.                           **\n");
> +	pr_warning("** unsafe for production use.                           **\n");
>  	pr_warning("**                                                      **\n");
>  	pr_warning("** If you see this message and you are not debugging    **\n");
>  	pr_warning("** the kernel, report this immediately to your vendor!  **\n");

Perhaps s/pr_warning/pr_warn/ too?


