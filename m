Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3JNVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:25:57 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:43678 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757390Ab3JNVZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:25:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:7576:7652:10004:10400:10848:11232:11658:11914:12114:12517:12519:12679:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plot21_8ab55d199684a
X-Filterd-Recvd-Size: 1631
Message-ID: <1381785951.12919.8.camel@joe-AO722>
Subject: Re: [PATCH -next] netdev: inet_timewait_sock.h missing semi-colon
 when KMEMCHECK is enabled
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Date: Mon, 14 Oct 2013 14:25:51 -0700
In-Reply-To: <525C5863.1000505@infradead.org>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
	 <525C47C0.2000907@infradead.org> <1381780437.12919.3.camel@joe-AO722>
	 <525C5863.1000505@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 13:47 -0700, Randy Dunlap wrote:
> On 10/14/13 12:53, Joe Perches wrote:
> > On Mon, 2013-10-14 at 12:36 -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Fix (a few hundred) build errors due to missing semi-colon when
> >> KMEMCHECK is enabled:

keyword: enabled...

> > Shouldn't this be done in kmemcheck.h?
> 
> This patch makes sense and probably should be merged
> but it does not fix the build errors that I reported.

Duh, enabled.  Yeah, you're sure...


