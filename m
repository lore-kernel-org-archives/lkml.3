Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaEZFFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:05:54 -0400
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:39028 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224AbaEZFFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:05:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cough12_6d486ca2d0b4c
X-Filterd-Recvd-Size: 1522
Message-ID: <1401080749.519.1.camel@joe-AO725>
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Adding blank
 lines
From: Joe Perches <joe@perches.com>
To: Chaitanya Hazarey <c@24.io>
Cc: gregkh@linuxfoundation.org, chad@dahc.us,
        michael.banken@mathe.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 25 May 2014 22:05:49 -0700
In-Reply-To: <1401080323-11767-1-git-send-email-c@24.io>
References: <1401080323-11767-1-git-send-email-c@24.io>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-25 at 21:58 -0700, Chaitanya Hazarey wrote:
> Added a blank line after declarations in many places to fix
> the following warning issued by checkpatch.pl:

Unrelated trivial note:

> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c

> @@ -2802,6 +2813,7 @@ int wdt_time_left(struct bpctl_dev *pbpctl_dev)
>  static int wdt_timer(struct bpctl_dev *pbpctl_dev, int *time_left)
>  {
>  	int ret = 0;
> +
>  	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
>  		{
>  			if (pbpctl_dev->wdt_status == WDT_STATUS_UNKNOWN)

unnecessary and ugly double brace


