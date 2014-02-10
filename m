Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBJQdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:33:47 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:40093 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831AbaBJQdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:33:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:3873:4250:4321:4605:5007:7652:7875:10004:10400:10848:11026:11232:11657:11658:11914:12043:12295:12296:12517:12519:12740:13069:13071:13141:13230:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pan50_2dbf650d4955
X-Filterd-Recvd-Size: 2664
Message-ID: <1392050018.2507.6.camel@joe-AO722>
Subject: Re: [Resend PATCH] staging : ion : Fix some checkpatch warnings and
 an error
From: Joe Perches <joe@perches.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, swetland@google.com, john.stultz@linaro.org,
        rebecca@android.com, ccross@android.com, ohaugan@codeaurora.org,
        romlem@google.com, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Date: Mon, 10 Feb 2014 08:33:38 -0800
In-Reply-To: <1861074.WmPcbRBdNV@daeseok-laptop.cloud.net>
References: <1861074.WmPcbRBdNV@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 20:25 +0900, Daeseok Youn wrote:

> Warning:
>  - Unnecessary space after function pointer name
>  - quoted string split across lines
> 
> Error:
>  - return is not a function, parentheses are not required

Hi.

checkpatch issuing either an ERROR or WARNING isn't
really relevant to the subject.

This isn't really a resend.  It's a different version
and so the subject should not say "Resend".  Ideally,
you send this with a subject like:

[PATCH V2] staging: ion: Whitespace neatening

and if needed again:

[PATCH V3] staging: ion: Whitespace neatening

etc...

and below:

> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
[]
> @@ -55,7 +55,7 @@ struct ion_device {
>  	struct mutex buffer_lock;
>  	struct rw_semaphore lock;
>  	struct plist_head heaps;
> -	long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
> +	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>  			      unsigned long arg);

Please realign the arguments to the open parenthesis like:

	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
			     unsigned long arg);

> diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
[]
> @@ -100,18 +100,18 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
>   * map_dma and map_kernel return pointer on success, ERR_PTR on error.
>   */
>  struct ion_heap_ops {
> -	int (*allocate) (struct ion_heap *heap,
> +	int (*allocate)(struct ion_heap *heap,
>  			 struct ion_buffer *buffer, unsigned long len,
>  			 unsigned long align, unsigned long flags);

realignment here too

etc.

