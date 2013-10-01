Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3JASng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:43:36 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:55093 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557Ab3JASnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:43:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:4250:4321:5007:6642:7576:7652:9545:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meat46_173bf65ba654
X-Filterd-Recvd-Size: 2052
Message-ID: <1380653008.1924.10.camel@joe-AO722>
Subject: Re: [PATCH 2/2] skd: Restricted pr_debug() lines to 80 characters
From: Joe Perches <joe@perches.com>
To: OS Engineering <osengineering@stec-inc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Date: Tue, 01 Oct 2013 11:43:28 -0700
In-Reply-To: <26D762E250385C4D8E9D6EC3C8E47DC11E70588B@sambx4.stec-inc.ad>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E70588B@sambx4.stec-inc.ad>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 12:29 +0000, OS Engineering wrote:
> From 6ff5102b3cd8047bb4bfb4d0165f289249e23bbe Mon Sep 17 00:00:00 2001
> From: rchinthekindi <rchinthekindi@stec-inc.com>
> Date: Tue, 1 Oct 2013 17:49:58 +0530
> Subject: [PATCH 2/2] skd: Restricted pr_debug() lines to 80 characters
> 
> Restricted pr_debug() lines to 80 characters

Please don't split formats across multiple lines.

> diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c


> @@ -2370,9 +2372,10 @@ static void skd_complete_internal(struct skd_device *skdev,
>  			skd_send_internal_skspcl(skdev, skspcl, WRITE_BUFFER);
>  		else {
>  			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
> -				pr_debug("%s:%s:%d TUR failed, don't send anymore"
> -					 "state 0x%x\n",
> -					 skdev->name, __func__, __LINE__, skdev->state);
> +				pr_debug("%s:%s:%d TUR failed, don't send"
> +					 " anymore state 0x%x\n",
> +					 skdev->name, __func__, __LINE__,
> +					 skdev->state);

etc...


