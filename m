Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaDFTCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 15:02:47 -0400
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:42163 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754358AbaDFTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 15:02:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:334:355:368:369:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: magic07_8c30d3cc0ac15
X-Filterd-Recvd-Size: 1999
Message-ID: <1396810962.2874.11.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging: rtl8192e: Fix sparse warning
From: Joe Perches <joe@perches.com>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 12:02:42 -0700
In-Reply-To: <5341A43A.3020200@gmail.com>
References: <5341A05A.5080403@gmail.com> <1396810170.2874.9.camel@joe-AO722>
	 <5341A43A.3020200@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 14:00 -0500, Joel Pelaez Jorge wrote:
> El 06/04/14 13:49, Joe Perches escribió:
> > On Sun, 2014-04-06 at 13:43 -0500, Joel Pelaez Jorge wrote:
[]
> >> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
[]
> >> -static struct iw_statistics *r8192_get_wireless_stats(struct net_device
> >> *dev)
> >> +struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
> >>    {
> >>    	struct r8192_priv *priv = rtllib_priv(dev);
> >>    	struct rtllib_device *ieee = priv->rtllib;
> >
> > As far as I can tell, there's no reason this should
> > be declared in the .h file and it should stay static
> > and not be exposed at all.
[]
> In the source "rtl_core.c" is possible to use the symbol
> r8192_get_wireless_stats, if WIRELESS_EXT has specifics values.
> 
> Although this scenario is unlikely to happen, is better prepare
> this code for it.

Huh?  This makes no sense to me.
Maybe you can expand a bit here.

> Also, a better way will be delete 'extern' reference to symbol
> in header file and source file.

That's what I said.

