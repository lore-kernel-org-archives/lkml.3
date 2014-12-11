Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbaLKDFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:05:06 -0500
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:47128 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933176AbaLKDFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:05:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:3873:3874:4250:4321:4605:5007:6261:7576:7903:10004:10400:10471:10848:11026:11232:11658:11914:12048:12517:12519:12679:12740:13019:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat55_ea752d9aca4c
X-Filterd-Recvd-Size: 2030
Message-ID: <1418267099.18092.28.camel@perches.com>
Subject: default enable sparse __CHECK_ENDIAN__ (was: Re: [PATCH v7 2/3]
 net: Add Keystone NetCP ethernet driver)
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>, Michal Marek <mmarek@suse.cz>
Cc: m-karicheri2@ti.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, linux-sparse@vger.kernel.org
Date: Wed, 10 Dec 2014 19:04:59 -0800
In-Reply-To: <20141210.204110.618599360537141819.davem@davemloft.net>
References: <1417556503-22290-3-git-send-email-m-karicheri2@ti.com>
	 <20141209.131053.2026868499542642866.davem@davemloft.net>
	 <5488BB96.9070609@ti.com>
	 <20141210.204110.618599360537141819.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 20:41 -0500, David Miller wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> > Are you referring to the static code analyser sparse that is invoked
> > through?
> You have to explicitly enable endian checking, it's not on by
> default.

There don't seem to be thousands of warnings anymore.

Maybe it's time to default enable it when using C=?

from: Documentation/sparse.txt:

The optional make variable CF can be used to pass arguments to sparse.  The
build system passes -Wbitwise to sparse automatically.  To perform endianness
checks, you may define __CHECK_ENDIAN__:

        make C=2 CF="-D__CHECK_ENDIAN__"

These checks are disabled by default as they generate a host of warnings.



