Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbbAUQk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:40:59 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:49630 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752334AbbAUQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:40:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3872:3874:4321:5007:6119:6261:6742:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spot53_4103d8589d11f
X-Filterd-Recvd-Size: 2171
Message-ID: <1421858444.10574.14.camel@perches.com>
Subject: Re: unclear ipv6 redirect message (was Re: [PATCH v3 2/3] mfd:
 lubbock_io: add lubbock_io board)
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: netdev <netdev@vger.kernel.org>, Robert Jarzmik <robert.jarzmik@free.fr>,
        Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Date: Wed, 21 Jan 2015 08:40:44 -0800
In-Reply-To: <20150121161059.GT26493@n2100.arm.linux.org.uk>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
	 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
	 <20150119091705.GG21886@x1> <87ppaah9k5.fsf@free.fr>
	 <20150120102919.GP5767@x1> <20150120115658.GJ26493@n2100.arm.linux.org.uk>
	 <873874fuei.fsf@free.fr> <20150121094453.GO26493@n2100.arm.linux.org.uk>
	 <1421856321.10574.13.camel@perches.com>
	 <20150121161059.GT26493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 16:11 +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 21, 2015 at 08:05:21AM -0800, Joe Perches wrote:
> > (adding netdev)
> 
> I wasn't actually reporting that as an issue; I was using it as an
> example.  It's from a very old kernel (2.6.27.21) which I run on one
> of my old x86 machines.

It's still the same code.
If the message can be improved, why not do it?

