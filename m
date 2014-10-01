Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaJANnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:43:52 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:35459 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbaJANnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:43:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3870:3871:3872:4321:5007:7514:7652:7903:10004:10400:10848:10967:11026:11232:11657:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hate31_42b00774a60a
X-Filterd-Recvd-Size: 1594
Message-ID: <1412171027.3247.6.camel@joe-AO725>
Subject: Re: [PATCH net-next] et131x: Add PCIe gigabit ethernet driver
 et131x to drivers/net
From: Joe Perches <joe@perches.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Mark Einon <mark.einon@gmail.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 01 Oct 2014 06:43:47 -0700
In-Reply-To: <20141001124500.GH3279@distanz.ch>
References: <1412112586-2194-1-git-send-email-mark.einon@gmail.com>
	 <20141001124500.GH3279@distanz.ch>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 14:45 +0200, Tobias Klauser wrote:
> On 2014-09-30 at 23:29:46 +0200, Mark Einon <mark.einon@gmail.com> wrote:
> > This adds the ethernet driver for Agere et131x devices to
> > drivers/net/ethernet.
[]
> > diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
[]
> > +	rc = pci_enable_device(pdev);
> > +	if (rc < 0) {
> > +		dev_err(&pdev->dev, "pci_enable_device() failed\n");
> > +		goto out;
> 
> Nit: Just return rc here.

I don't think it matters at all.

It's a predictable style to use common exit blocks.

It's a maintainer's right to do it in whatever
fashion is desired.


