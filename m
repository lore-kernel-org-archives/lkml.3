Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbaGEAYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 20:24:15 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:46553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753619AbaGEAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 20:24:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13071:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0
X-HE-Tag: crate24_7bdda67d0ac1e
X-Filterd-Recvd-Size: 1861
Message-ID: <1404519849.6384.32.camel@joe-AO725>
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
From: Joe Perches <joe@perches.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 17:24:09 -0700
In-Reply-To: <3976291.2Ne0xJphcZ@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	 <3856718.HehN4Xqlpl@myon.chronox.de> <1404518973.6384.30.camel@joe-AO725>
	 <3976291.2Ne0xJphcZ@myon.chronox.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-05 at 02:15 +0200, Stephan Mueller wrote:
> Am Freitag, 4. Juli 2014, 17:09:33 schrieb Joe Perches:
> > On Sat, 2014-07-05 at 01:57 +0200, Stephan Mueller wrote:
> > > And I also get the same output. Yet I am not sure how that code can be
> > > compared to the code in the kernel.
> > 
> > What that code shows is that the ARRAY_SIZE
> > type is size_t.
> > 
> > The difference is ARRAY_SIZE in the kernel
> > should be output with %zu.
> 
> Using %zu works without a warning on my 64 bit machine. So you are saying that 
> ARRAY_SIZE will always be size_t on every architecture? If yes, I will update 
> my patch.

Hi again.

ARRAY_SIZE is size_t in all architectures.


