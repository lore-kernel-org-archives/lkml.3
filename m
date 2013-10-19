Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3JSWnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:43:25 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:57022 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750824Ab3JSWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:43:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2110:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13071:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: milk63_57c50a3ddb462
X-Filterd-Recvd-Size: 1542
Message-ID: <1382222601.2041.31.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: add Bluetooth UUID %pU[rR] format specifier
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 19 Oct 2013 15:43:21 -0700
In-Reply-To: <D753FB79-8E82-4F36-881A-68858145B688@holtmann.org>
References: <1382199949-26779-1-git-send-email-marcel@holtmann.org>
	 <1382217893.2041.27.camel@joe-AO722>
	 <D753FB79-8E82-4F36-881A-68858145B688@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-20 at 00:30 +0200, Marcel Holtmann wrote:
> Hi Joe,

Hi Marcel

> > Could there ever be a little endian reversed UUID?
> I honestly do not know. I looked at the little endian one and it
> looked a bit heavy misplaced if we would use a reversed stream of
> bytes.
> > Might it be useful to change this to:
> > 
> > 	while (isalpha(*++fmt)) {
> > 		switch (*fmt) {
> 
> I didn't do it so the modifier didn't get any longer than it needs to be.

Given that %pU is big endian by default, then the modifier
doesn't have to get longer.  %pUR and %pUr would still be
big endian and this would simply allow %pULR if necessary.

cheers, Joe

