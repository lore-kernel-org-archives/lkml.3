Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3ITOyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:54:46 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:41429 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751704Ab3ITOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:54:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3870:3871:3872:3873:3874:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12050:12114:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mind16_805d487aedb5b
X-Filterd-Recvd-Size: 1514
Message-ID: <1379688880.2021.38.camel@joe-AO722>
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
 rules
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Sep 2013 07:54:40 -0700
In-Reply-To: <1379615474.22168.13.camel@joe-AO722>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	 <20130919.135628.1201613770803318193.davem@davemloft.net>
	 <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	 <1379615474.22168.13.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 11:31 -0700, Joe Perches wrote:
> Networking is once again "special", so at least document
> how it's working today in the hope that doing so makes
> less work for all that actually read the documentation.

David, why did you mark this N/A is patchwork?
It's your rule, why not document it?


