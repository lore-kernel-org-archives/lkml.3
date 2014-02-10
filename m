Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaBJWAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:00:04 -0500
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:48872 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753140AbaBJWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:00:00 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3872:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stamp97_5702e6cf7802b
X-Filterd-Recvd-Size: 1312
Message-ID: <1392069596.2507.23.camel@joe-AO722>
Subject: Re: WARNING: Unnecessary parentheses - maybe == should be = ?
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 13:59:56 -0800
In-Reply-To: <20140210202411.GD26776@mwanda>
References: <20140210092710.GA10899@elgon.mountain>
	 <1392052786.2507.20.camel@joe-AO722> <20140210202411.GD26776@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 23:24 +0300, Dan Carpenter wrote:
> On Mon, Feb 10, 2014 at 09:19:46AM -0800, Joe Perches wrote:
> > On Mon, 2014-02-10 at 12:27 +0300, Dan Carpenter wrote:
> > > We do not want to encourage a million
> > > first patch submitters to start introducing = vs == bugs.
> > Definitely true and I didn't think of that.
> So long as we can re-phrase it then I don't have a problem with the
> warning.

Do you have a suggested phrasing?


