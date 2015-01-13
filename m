Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbbAMRSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:18:07 -0500
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:39923 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752253AbbAMRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:18:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3874:4321:4384:5007:6261:8660:10004:10400:10848:11026:11232:11658:11914:12043:12114:12438:12517:12519:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: apple00_4604b7327ae59
X-Filterd-Recvd-Size: 1328
Message-ID: <1421169479.9233.25.camel@perches.com>
Subject: Re: [PATCH] mISDN: avoid arch specific __builtin_return_address call
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Jan 2015 09:17:59 -0800
In-Reply-To: <1816278.9Bv8N8K5IB@wuerfel>
References: <1816278.9Bv8N8K5IB@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 17:10 +0100, Arnd Bergmann wrote:
> Not all architectures are able to call __builtin_return_address().
> On ARM, the mISDN code produces this warning:
> 
> hardware/mISDN/w6692.c: In function 'w6692_dctrl':
> hardware/mISDN/w6692.c:1181:75: warning: unsupported argument to '__builtin_return_address'
>   pr_debug("%s: %s dev(%d) open from %p\n", card->name, __func__,

I didn't know that tidbit. Thanks.


