Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaESUBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:01:12 -0400
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:60285 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932143AbaESUBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:01:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3653:3865:3867:3870:3871:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12049:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tin28_6120c0e694732
X-Filterd-Recvd-Size: 1408
Message-ID: <1400529666.14238.27.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/jffs2/compr.c: remove 0 assignment on static
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 19 May 2014 13:01:06 -0700
In-Reply-To: <1400529361.3036.63.camel@shinybook.infradead.org>
References: <20140519213145.e75dbd1aa74fc2ccd9193686@skynet.be>
	 <1400529199.14238.24.camel@joe-AO725>
	 <1400529361.3036.63.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 20:56 +0100, David Woodhouse wrote:
> On Mon, 2014-05-19 at 12:53 -0700, Joe Perches wrote:
> > Maybe all the uint32_t uses in fs/jffs2/
> > would be nicer as u32.
> 
> No thanks. We prefer this code in standard C.
> 1999 is a long time ago now...

That's certainly your choice you nonconformist...

$ git grep -w u32 | wc -l
138805
$ git grep -w uint32_t | wc -l
20420

But I gather you don't like to party?


