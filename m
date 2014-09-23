Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaIWTSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:18:01 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:44102 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751638AbaIWTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:17:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:4250:4321:5007:6120:7514:7652:7875:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: geese65_7fa17fd112503
X-Filterd-Recvd-Size: 1787
Message-ID: <1411499875.29268.7.camel@joe-AO725>
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Mark Einon <mark.einon@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
        gregkh@linuxfoundation.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2014 12:17:55 -0700
In-Reply-To: <20140923190242.GA8096@electric-eye.fr.zoreil.com>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
	 <20140923072251.GD4657@distanz.ch>
	 <20140923094614.GA5130@leicester.auvation.com>
	 <20140923190242.GA8096@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 21:02 +0200, Francois Romieu wrote:
> Mark Einon <mark.einon@gmail.com> :
> [...]
> > > No need for the #define here, just assigne et131x_pm_ops to .driver.pm
> > > directly, its members will be NULL and thus never called. Also, you can
> > > make et131x_pm_ops const.
> > 
> > Ok, I can change this.
> > 
> > Btw, this appears to be a fairly standard way of using .driver.pm among
> > ethernet drivers, e.g. see 3com/3c59x.c, atheros, marvell... - perhaps
> > there is a case for changing all instances of this code?
> 
> How about kernel tinification ?

The tiny case where a large number of ethernet drivers are included?

