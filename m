Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3IYPfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:35:48 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:35018 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751501Ab3IYPfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:35:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7903:8957:9010:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rose64_324883525d913
X-Filterd-Recvd-Size: 1648
Message-ID: <1380123344.17366.5.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 08:35:44 -0700
In-Reply-To: <20130925152432.GY13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
	 <20130925152432.GY13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 16:24 +0100, Al Viro wrote:
> On Tue, Sep 24, 2013 at 11:38:54AM -0700, Joe Perches wrote:
> > Checkpatch doesn't currently find CamelCase definitions
> > of structs, unions or enums.
> > 
> > Add that ability.
> 
> Fix your regex.  As it is, it catches the things that are not camelcase
> by any stretch of definition - [A-Z][a-z]+ will get caught by that and
> it's neither camelcase nor something that ought to be discouraged for
> e.g. enum member names.
> 
> CamelCase refers to caps in the middle of a compound, used to visually
> separate them.

We disagree.

I think Propercase should be discouraged.
ie: Qdisc et al.

Anyway, this finds things like Qdisc in
headers and adds them to the "ignore" list.


