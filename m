Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3IWUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:34:11 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:41650 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752850Ab3IWUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:34:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2540:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:7875:9010:9108:10004:10400:10848:11232:11658:11914:12114:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boot25_41027bb191817
X-Filterd-Recvd-Size: 1904
Message-ID: <1379968445.3575.60.camel@joe-AO722>
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
 rules
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>, stephen@networkplumber.org,
        netdev@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Date: Mon, 23 Sep 2013 13:34:05 -0700
In-Reply-To: <20130922185104.GA7515@infradead.org>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	 <20130919.135628.1201613770803318193.davem@davemloft.net>
	 <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	 <1379615474.22168.13.camel@joe-AO722> <20130922185104.GA7515@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 11:51 -0700, Christoph Hellwig wrote:
> This is also the preferred way to do it for XFS.  Maybe word it in a way
> that we can easily add subsystems.
> 
> To me it generally seems to be the best way to do it - having random Ccs
> and lots of stable trees doesn't seem like a very good way of handling
> it.

Maybe adding a mechanism to MAINTAINERS would be better.
Maybe a default B: (backport?) of stable@vger.kernel.org
with a per-subsystem override?

SUBSYSTEM TYPE
M:	maintainer@email.address
L:	list@email.address
S:	Supported
F:	file/pattern/
B:	stable@email.address


