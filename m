Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaCRRhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:37:08 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:34905 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932172AbaCRRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:37:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2919:3138:3139:3140:3141:3142:3622:3865:4184:4321:5007:7652:10004:10400:10848:11658:11914:12517:12519:12740:13069:13071:13161:13229:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owl99_204c37c530204
X-Filterd-Recvd-Size: 1235
Message-ID: <1395164220.2812.59.camel@joe-AO722>
Subject: Re: [patch 08/12] can: c_can: Makethe code readable
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 18 Mar 2014 10:37:00 -0700
In-Reply-To: <20140318171127.430027680@linutronix.de>
References: <20140318171007.528610837@linutronix.de>
	 <20140318171127.430027680@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 17:19 +0000, Thomas Gleixner wrote:

[patch]

Hi

The multi-while loop

	while ((obj = ffs(pend)) && quota > 0) {
		...
	} while ((obj = ffs(pend)) && quota > 0);

looks, umm, unusual.


