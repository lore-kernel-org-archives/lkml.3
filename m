Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IJQr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:47:27 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:39981 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751872Ab3IJQr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:47:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:2896:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3873:3874:4321:5007:7576:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: feet27_5dca283a7d622
X-Filterd-Recvd-Size: 1740
Message-ID: <1378831644.15812.13.camel@joe-AO722>
Subject: Re: [PATCH] mei: Don't dev_err() on suspend
From: Joe Perches <joe@perches.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Adam Jackson <ajax@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Sep 2013 09:47:24 -0700
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AEC1D72@HASMSX106.ger.corp.intel.com>
References: <1378828483-11813-1-git-send-email-ajax@redhat.com>
	 <1378829187.15812.11.camel@joe-AO722>
	 <5B8DA87D05A7694D9FA63FD143655C1B1AEC1D72@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 16:37 +0000, Winkler, Tomas wrote:
> From: Joe Perches [mailto:joe@perches.com]
> > On Tue, 2013-09-10 at 11:54 -0400, Adam Jackson wrote:
> > > Suspend isn't an error condition, and I'm sick of seeing this (and only
> > > this) on the console when I suspend with quiet boot enabled.
> > []
> > > diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
> > []
> > > @@ -262,7 +262,7 @@ static int mei_me_pci_suspend(struct device *device)
> > >  	if (!dev)
> > >  		return -ENODEV;
> > >
> > > -	dev_err(&pdev->dev, "suspend\n");
> > > +	dev_info(&pdev->dev, "suspend\n");
> > 
> > dev_dbg instead?
> 
> Yes, but I believe we fixed that long ago were do you see this?

drivers/misc/mei/pci-me.c of both linus and -next


