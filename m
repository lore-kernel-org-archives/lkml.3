Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3K2W7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:59:07 -0500
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:42985 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750905Ab3K2W7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:59:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: floor30_88f361b399624
X-Filterd-Recvd-Size: 1531
Message-ID: <1385765939.12210.36.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
From: Joe Perches <joe@perches.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Fri, 29 Nov 2013 14:58:59 -0800
In-Reply-To: <52991A39.8030103@metafoo.de>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1385663555.12210.19.camel@joe-AO722> <1385729760.1871.23.camel@smile>
	 <1385763040.12210.34.camel@joe-AO722> <52991A39.8030103@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-29 at 23:50 +0100, Lars-Peter Clausen wrote:
> On 11/29/2013 11:10 PM, Joe Perches wrote:
[]
> > $ cat dma_addr_t.cocci
> > @@
> > dma_addr_t foo;
> > @@
> >
> > * (unsigned long long)foo;
> 
> Remove the semicolon, otherwise it will only match statements which are nothing 
> but the cast.

Duh, thanks.


