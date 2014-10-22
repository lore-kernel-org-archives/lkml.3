Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaJVDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:16:56 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:49158 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752039AbaJVDQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:16:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3872:4321:5007:6261:6742:7974:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13072:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clock08_7624a6ac6531c
X-Filterd-Recvd-Size: 1986
Message-ID: <1413947810.18654.0.camel@perches.com>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of
 the kernel
From: Joe Perches <joe@perches.com>
To: Rom Lemarchand <romlem@android.com>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Date: Tue, 21 Oct 2014 20:16:50 -0700
In-Reply-To: <CAABpnA8Oe9_8r9hyAQADPwNh4Zn63tUQAUD7f0WSYh1xcdtz6g@mail.gmail.com>
References: <20141016124741.GA3832@kroah.com>
	 <20141017092601.GH23154@mwanda> <20141019220547.GC3780@kroah.com>
	 <20141020092049.GJ23154@mwanda>
	 <CAMP5Xgcm-sxd3rf3VA1ZO44bUT1+u_QG1AAdjzK39q0ynfsZGQ@mail.gmail.com>
	 <CAABpnA8Oe9_8r9hyAQADPwNh4Zn63tUQAUD7f0WSYh1xcdtz6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 20:10 -0700, Rom Lemarchand wrote:
> On the topic of maintainers for binder: both Arve Hjønnevåg
> (arve@android.com) and Riley Andrews (riandrews@android.com) have
> volunteered to be co-maintainers with Greg.
> 
> We would also like to make kernel-team@android.com the maintainer of
> the whole android directory.

It's generally better to have people as maintainers than
using nameless email addresses.

