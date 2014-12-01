Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaLARDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:03:48 -0500
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:60330 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753812AbaLARDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:03:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:4321:5007:6261:8784:8957:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slope95_3d8adc3311d5e
X-Filterd-Recvd-Size: 1498
Message-ID: <1417453419.4894.4.camel@perches.com>
Subject: Re: [PATCH] staging: rtl8723au: hal: Removed spaces before starting
 of a line
From: Joe Perches <joe@perches.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        es.Sorensen@redhat.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2014 09:03:39 -0800
In-Reply-To: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
References: <1417449197-3227-1-git-send-email-anjanasasindran123@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 21:23 +0530, Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning:
> WARNING: please, no spaces at the start of a line
[]
> diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
[]
> @@ -20,7 +20,7 @@ odm_ConfigRFReg_8723A(
>  	struct dm_odm_t *pDM_Odm,
>  	u32					Addr,
>  	u32					Data,
> -  enum RF_RADIO_PATH     RF_PATH,
> +enum RF_RADIO_PATH     RF_PATH,
.
This should have a leading tab indentation



