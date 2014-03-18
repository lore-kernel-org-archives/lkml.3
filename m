Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaCRUfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:35:07 -0400
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:50420 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757792AbaCRUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:35:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2729:2828:2904:3138:3139:3140:3141:3142:3622:3865:3868:3871:3872:3874:4225:4250:4321:5007:7652:7901:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: card46_8327a7203f154
X-Filterd-Recvd-Size: 1538
Message-ID: <1395174900.2812.87.camel@joe-AO722>
Subject: Re: can: c_can: Reduce interrupt load by 50%
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 18 Mar 2014 13:35:00 -0700
In-Reply-To: <alpine.DEB.2.02.1403182114470.18573@ionos.tec.linutronix.de>
References: <20140318171007.528610837@linutronix.de>
	 <20140318171127.923041002@linutronix.de>
	 <alpine.DEB.2.02.1403182114470.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 21:18 +0100, Thomas Gleixner wrote:
> The driver handles pointlessly TWO interrupts per packet. The reason
> is that it enables the status interrupt which fires for each rx and tx
> packet and it enables the per message object interrupts as well.

Are the message object interrupts a possible workaround
for any defective hardware?

> performance improment

Now that the code's not being written by amateurs?



