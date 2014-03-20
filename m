Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbaCTVIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:08:18 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:42661 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759424AbaCTVIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:08:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3872:3873:4321:5007:6120:7652:7901:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun66_6527488b49e47
X-Filterd-Recvd-Size: 1210
Message-ID: <1395349693.7776.52.camel@joe-AO722>
Subject: Re: [PATCH] rtc: add support for maxim dallas rtc ds1347
From: Joe Perches <joe@perches.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Date: Thu, 20 Mar 2014 14:08:13 -0700
In-Reply-To: <20140320220137.6a7745cd@linux.lan.towertech.it>
References: <532B3AB9.5050809@gmail.com>
	 <1395343195.7776.37.camel@joe-AO722>
	 <20140320220137.6a7745cd@linux.lan.towertech.it>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 22:01 +0100, Alessandro Zummo wrote:
> On Thu, 20 Mar 2014 12:19:55 -0700
> Joe Perches <joe@perches.com> wrote:
> > This depends on how long you want to live, but it could be
> > 	while (dt->tm_year >= 100) 
>  dt->tm_year % 100 ?

Sure, if you don't mind the divide.


