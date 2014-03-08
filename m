Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaCHQjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 11:39:42 -0500
Received: from smtprelay0001.hostedemail.com ([216.40.44.1]:43538 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591AbaCHQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:39:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2828:2917:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3874:4321:5007:6120:7652:7903:9010:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13072:13311:13357:14096:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knot68_715b5b81de012
X-Filterd-Recvd-Size: 2389
Message-ID: <1394296777.6972.34.camel@joe-AO722>
Subject: Re: [RFC V1] MAINTAINERS: Addition of Dialog Semiconductor files
From: Joe Perches <joe@perches.com>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Date: Sat, 08 Mar 2014 08:39:37 -0800
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7A0C6C9FD@SW-EX-MBX02.diasemi.com>
References: <201403071145.s27BjBpg020540@swsrvapps-01.diasemi.com>
	 <1394209504.16156.70.camel@joe-AO722>
	 <6ED8E3B22081A4459DAC7699F3695FB7A0C6C9FD@SW-EX-MBX02.diasemi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 10:45 +0000, Opensource [Steve Twiss] wrote:
> On 07 March 2014 16:25 Joe Perches wrote:
> 
> >> Dialog Semiconductor would like to add a new section called DIALOG
> >> SEMICONDUCTOR DRIVERS which contains the new support mailing list
> >> <support.opensource@diasemi.com> for Dialog supported drivers.
> >
> >That's a fine idea.
> >
> >It's generally better to have a person rather
> >than an exploder as a maintainer.
> >
> >It's also fine to have an exploder listed too.
[]
> In the past, mails were sent to Dialog e-mail addresses that were no
> longer valid and so the notifications were missed. To rectify this,
> we were hoping to avoid personalised e-mail addresses in the
> MAINTAINERS file (and at the same time avoid putting individual
> entries for all our drivers).

It's possible for all of the email addresses that an
exploder delivers to be out-of-date too.

> We will still add our personal e-mails to individual files, but we were
> hoping that by adding the support.opensource address to just the
> MAINTAINERS file, this would allow us to catch developer changes at
> our side.

As I said, exploder email addresses are fine, there's no
requirement to have a bunch of different SECTIONS.


