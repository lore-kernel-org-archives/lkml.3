Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3KASdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:33:00 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:44276 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752019Ab3KASdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:33:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:2899:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12050:12296:12517:12519:12555:12740:13069:13071:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: force07_7140e8bc3ec08
X-Filterd-Recvd-Size: 1254
Message-ID: <1383330777.3042.2.camel@joe-AO722>
Subject: Re: [Suggestion] about latest commit for
 "scripts/get_maintainers.pl"
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 01 Nov 2013 11:32:57 -0700
In-Reply-To: <52738E90.6040104@asianux.com>
References: <52738E90.6040104@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 19:20 +0800, Chen Gang wrote:
> Hello Joe:

Hello Chen Gang.

> I meet a failure about "scripts/get_maintainers.pl", it is about the
> commit "750432d get_maintainer.pl incomplete output", if use original
> "scripts/get_maintainer.pl", it will be OK.
> 
> Please help check, thanks.

I don't get that effect.
I'll look into it and see what I find next week.
You seem to have a work-around available.

Joe

