Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbaCRV1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:27:22 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:52916 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751590AbaCRV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:27:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:3872:3873:3874:4321:5007:6119:7652:7901:7903:9040:10007:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: town45_572f98ae650f
X-Filterd-Recvd-Size: 1638
Message-ID: <1395178036.2812.91.camel@joe-AO722>
Subject: Re: can: c_can: Reduce interrupt load by 50%
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 18 Mar 2014 14:27:16 -0700
In-Reply-To: <alpine.DEB.2.02.1403182142390.18573@ionos.tec.linutronix.de>
References: <20140318171007.528610837@linutronix.de>
	 <20140318171127.923041002@linutronix.de>
	 <alpine.DEB.2.02.1403182114470.18573@ionos.tec.linutronix.de>
	 <1395174900.2812.87.camel@joe-AO722>
	 <alpine.DEB.2.02.1403182142390.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 21:43 +0100, Thomas Gleixner wrote:
> On Tue, 18 Mar 2014, Joe Perches wrote:
> > On Tue, 2014-03-18 at 21:18 +0100, Thomas Gleixner wrote:
> > > performance improment
> > Now that the code's not being written by amateurs?
> You found a typo. Great, you can keep it!

Given it's in a commit log, we all get to keep it.

Please do try to ratchet down the snark level of your
commit messages.

cheers, Joe


