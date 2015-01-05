Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbbAENi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:38:57 -0500
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:40956 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923AbbAENi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:38:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3872:3874:4321:4605:5007:6119:6261:7514:7576:7903:10004:10400:10848:11232:11233:11658:11914:12043:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: snow99_13960c57ecb0b
X-Filterd-Recvd-Size: 1772
Message-ID: <1420465133.2652.12.camel@perches.com>
Subject: Re: [PATCH 3/3] spi:spi-gpio: fixed space coding styple issue
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@kernel.org>
Cc: nizamhaider786@gmail.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Jan 2015 05:38:53 -0800
In-Reply-To: <20150105133014.GP11764@sirena.org.uk>
References: <1420459263-2190-1-git-send-email-nizamhaider786@gmail.com>
	 <1420461363.2652.6.camel@perches.com>
	 <20150105133014.GP11764@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 13:30 +0000, Mark Brown wrote:
> On Mon, Jan 05, 2015 at 04:36:03AM -0800, Joe Perches wrote:
> > On Mon, 2015-01-05 at 17:31 +0530, nizamhaider786@gmail.com wrote:
> > > From: Nizam Haider <nizamhaider786@gmail.com>
> 
> > > fixed a coding style issue
> 
> > This is a checkpatch defect and not a coding styple (style) issue.
> 
> > Please don't blindly take checkpatch messages as dicta.
> 
> No, it's a coding style thing.

It's a coding style consistency thing.

> It may have been identified by
> checkpatch but that's what it is.

__pure is a #define for a gcc attribute

include/linux/compiler-gcc.h:#define __pure                             __attribute__((pure))

macro attributes are almost always used
with space separators in the kernel.

All instances of __pure in the kernel have
a space before the use.

