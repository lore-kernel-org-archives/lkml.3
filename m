Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab3LXGn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 01:43:56 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:56321 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750870Ab3LXGnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 01:43:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:3873:4321:5007:7652:10004:10400:10848:11232:11658:11914:12050:12296:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bear72_3f20bb12ab222
X-Filterd-Recvd-Size: 1690
Message-ID: <1387867432.2259.2.camel@joe-AO722>
Subject: Re: [PATCH] drivers: firmware: edd: fixed coding style errors
From: Joe Perches <joe@perches.com>
To: Derek Perrin <d.roc16@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 23 Dec 2013 22:43:52 -0800
In-Reply-To: <2057495.KkFWMBqotF@slave1>
References: <1387747039-14098-1-git-send-email-d.roc16@gmail.com>
	 <1387750419.22671.25.camel@joe-AO722> <2057495.KkFWMBqotF@slave1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 18:53 -0600, Derek Perrin wrote:
> On Sunday, December 22, 2013 02:13:39 PM Joe Perches wrote:
> > On Sun, 2013-12-22 at 15:17 -0600, Derek Perrin wrote:
[]
> > One trivial bit too,
> > > diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
[]
> > > -	ssize_t(*show) (struct edd_device * edev, char *buf);
> > > -	int (*test) (struct edd_device * edev);
> > > +	ssize_t(*show) (struct edd_device *edev, char *buf);
> > > +	int (*test) (struct edd_device *edev);
> > 
> > I think most prefer function pointer prototypes like:
> > 
> > 	size_t (*show)(struct edd_device *edev, char *buf);
> > 	int (*test)(struct edd_device *edev);

> I'm not seeing any 
> difference between what I did and what you said about the function pointer 
> prototypes. 

	type (*funcptr) (args...)
vs
	type (*funcptr)(args...)

2nd is preferred


