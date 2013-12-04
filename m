Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3LDHpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:45:20 -0500
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:54795 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752077Ab3LDHpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:45:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3871:3872:3873:3874:4321:5007:7652:8531:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: club30_10f30c4f06907
X-Filterd-Recvd-Size: 1873
Message-ID: <1386143115.30493.48.camel@joe-AO722>
Subject: Re: [PATCH] Staging: speakup: synth.c: removed a space
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Aldo Iljazi <mail@aldo.io>, Samuel Thibault <samuel.thibault@ens-lyon.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Tue, 03 Dec 2013 23:45:15 -0800
In-Reply-To: <20131204073824.GP28413@mwanda>
References: <1386101283-14650-1-git-send-email-mail@aldo.io>
	 <20131203221703.GE8138@type> <20131204043515.GB6909@linux>
	 <20131204073824.GP28413@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 10:38 +0300, Dan Carpenter wrote:
> On Wed, Dec 04, 2013 at 06:35:15AM +0200, Aldo Iljazi wrote:
> >  Samuel Thibault wrote:
> > 
> > > Err, I'd rather make it really visible that the for loop doesn't have
> > > its first statement?
> > 
> > Wouldn't it be better if you add a comment there? So it would follow the
> > coding style?
> 
> No.  Adding obvious comments is more annoying than the space.
> 
> This seems like a small bug in checkpatch.pl.  Joe, the problem is this
> code:
> 
> 	for ( ; x; x++) {
> 
> It's complaining about the space character before the semicolon.

Shrug.  checkpatch isn't and can't be perfect.

I think it's for things like

	for (;;)

and that's better than

	for ( ; ; )
or
	for ( ;; )
or
	for ( ;;)


