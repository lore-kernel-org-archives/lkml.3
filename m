Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3JIGUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:20:13 -0400
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:54553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751848Ab3JIGUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:20:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3870:3871:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wine11_588acb86edd28
X-Filterd-Recvd-Size: 1455
Message-ID: <1381299606.2040.21.camel@joe-AO722>
Subject: Re: [PATCH] rtc: rtc-puv3: use dev_dbg() instead of pr_debug()
From: Joe Perches <joe@perches.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Date: Tue, 08 Oct 2013 23:20:06 -0700
In-Reply-To: <1381297783-24658-1-git-send-email-sangjung.woo@samsung.com>
References: <1381297783-24658-1-git-send-email-sangjung.woo@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 14:49 +0900, Sangjung Woo wrote:
> Because dev_*() are used along with pr_debug() function in this code,
> the debug message is not tidy. This patch converts from pr_debug() to
> dev_dbg() since dev_*() are encouraged to use in device driver code.
[]
> diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
[]
> @@ -57,7 +57,7 @@ static void puv3_rtc_setaie(int to)
>  {
>  	unsigned int tmp;
>  
> -	pr_debug("%s: aie=%d\n", __func__, to);
> +	dev_dbg(dev, "%s: aie=%d\n", __func__, to);

Does this compile?


