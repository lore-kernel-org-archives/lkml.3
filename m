Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaCIWQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 18:16:00 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:38386 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752051AbaCIWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 18:15:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3873:4321:4823:5007:7652:8603:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13161:13184:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soap94_3400db693c21c
X-Filterd-Recvd-Size: 1506
Message-ID: <1394403355.30791.3.camel@joe-AO722>
Subject: Re: [PATCH 2/2] mm: Changed pr_warning() to pr_warn()
From: Joe Perches <joe@perches.com>
To: Choi Gi-yong <yong@gnoy.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Mar 2014 15:15:55 -0700
In-Reply-To: <1394352900-13629-1-git-send-email-yong@gnoy.org>
References: <1394352900-13629-1-git-send-email-yong@gnoy.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-09 at 17:15 +0900, Choi Gi-yong wrote:
> Signed-off-by: Choi Gi-yong <yong@gnoy.org>

[]

> diff --git a/mm/percpu.c b/mm/percpu.c

> @@ -812,8 +812,8 @@ fail_unlock:
>  fail_unlock_mutex:
>  	mutex_unlock(&pcpu_alloc_mutex);
>  	if (warn_limit) {
> -		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, "
> -			   "%s\n", size, align, err);
> +		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, %s\n",
> +	size, align, err);

The second line should use 3 tabs for indentation.

		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, %s\n",
			size, align, err);

If you want to become familiar with kernel style
and patching something, please practice on some
files in drivers/staging.

