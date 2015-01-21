Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbbAUREr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:04:47 -0500
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:39620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754375AbbAUREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:04:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:4321:5007:6261:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: back20_7f699cd53ac3b
X-Filterd-Recvd-Size: 1763
Message-ID: <1421859873.10574.17.camel@perches.com>
Subject: Re: [PATCH] staging: rtl8712: fix Missing a blank line after
 declarations
From: Joe Perches <joe@perches.com>
To: Lin Kassem <linsara1@gmail.com>
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        florian.c.chilhabel@googlemail.com, gregkh@linuxfoundation.org,
        gulsah.1004@gmail.com, shack@linux.com, thomas@grouk.net,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2015 09:04:33 -0800
In-Reply-To: <20150121144129.GA7195@lin-535U4C>
References: <20150121144129.GA7195@lin-535U4C>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 16:41 +0200, Lin Kassem wrote:
> This patch fixes the following checkpatch.pl warning:
> fix Missing a blank line after declarations

False positives.  Unnecessary changes.

> diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
[]
> @@ -129,6 +129,7 @@ struct dvobj_priv {
>  	struct _adapter *padapter;
>  	u32 nr_endpoint;
>  	u8   ishighspeed;
> +
>  	uint(*inirp_init)(struct _adapter *adapter);
>  	uint(*inirp_deinit)(struct _adapter *adapter);
>  	struct usb_device *pusbdev;
> @@ -166,6 +167,7 @@ struct _adapter {
>  	 pid_t evtThread;
>  	struct task_struct *xmitThread;
>  	pid_t recvThread;
> +
>  	uint(*dvobj_init)(struct _adapter *adapter);
>  	void (*dvobj_deinit)(struct _adapter *adapter);
>  	struct net_device *pnetdev;



