Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaIHLht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:37:49 -0400
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:52772 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395AbaIHLhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:37:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shame24_26b456bf8fc3a
X-Filterd-Recvd-Size: 1620
Message-ID: <1410176264.12560.3.camel@joe-AO725>
Subject: Re: [PATCH 2/3] staging: lustre: fix pointer whitespace style
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        gregkh@linuxfoundation.org, Hongchao Zhang <hongchao.zhang@intel.com>,
        Niu Yawei <yawei.niu@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Date: Mon, 08 Sep 2014 04:37:44 -0700
In-Reply-To: <20140908103208.GK6600@mwanda>
References: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
	 <1410025111-31422-2-git-send-email-sbaugh@andrew.cmu.edu>
	 <1410027543.2723.8.camel@joe-AO725> <20140908103208.GK6600@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 13:32 +0300, Dan Carpenter wrote:
> On Sat, Sep 06, 2014 at 11:19:03AM -0700, Joe Perches wrote:
> > Indexing a string array with an enum is generally unsafe.
> > I think it better to use a switch/case like:
> The reverse side of that argument is that switch statements are slower
> and uglier.

Uglier is true, safer is true too.
Slower depends.
Sometimes the actual code is identical.


