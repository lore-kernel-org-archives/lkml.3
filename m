Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3L1REg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 12:04:36 -0500
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:55011 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755301Ab3L1REe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 12:04:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:152:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:4250:4321:5007:7652:8531:10011:10400:10481:10848:11026:11232:11658:11783:11914:12517:12519:12740:13069:13311:13357:13894:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: bait79_27a1187f96d3c
X-Filterd-Recvd-Size: 1645
Message-ID: <1388250271.24123.4.camel@joe-AO722>
Subject: Re: [PATCH net-next v2 20/20] net: caif: slight optimization of
 addr compare
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dthxman@gmail.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 09:04:31 -0800
In-Reply-To: <52BEE7F0.1070506@gmail.com>
References: <52BE6D50.9000308@huawei.com>
	 <1388213953.24123.2.camel@joe-AO722> <52BEE7F0.1070506@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 23:02 +0800, Ding Tianhong wrote:
> 于 2013/12/28 14:59, Joe Perches 写道:
> > On Sat, 2013-12-28 at 14:18 +0800, Ding Tianhong wrote:
> >> Use possibly more efficient ether_addr_equal
> >> to instead of memcmp.
> > 
> > This may be a distinction without difference, but
> > is a CAIF seghead also an ethernet address?
> > 
> NO，this is a coincidence, the CAIF seghead is 6 bytes too,
> So from a logical point of view, maybe a new function with
> suitable name will be more reasonable here, but the name of
> ether_addr_equal is not correctly here.:)

So please remove this one from the series.


