Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbaGRWut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:50:49 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:49534 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762400AbaGRWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:50:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3871:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: swing85_75c537d5f9556
X-Filterd-Recvd-Size: 1287
Message-ID: <1405723807.14358.100.camel@joe-AO725>
Subject: Re: How to automate checkpatch && get_maintainers && git send-email
 of commits range?
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        kernelnewbies@kernelnewbies.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Fri, 18 Jul 2014 15:50:07 -0700
In-Reply-To: <1405723664.14358.98.camel@joe-AO725>
References: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
	 <20140718222215.GF18775@thunk.org> <1405723664.14358.98.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 15:47 -0700, Joe Perches wrote:
> On Fri, 2014-07-18 at 18:22 -0400, Theodore Ts'o wrote:
> >  and get_maintainers.pl.
> I think checkpatch

Umm, make that get_maintainer...

> is pretty good about cc'ing mostly the
> right folk by default.


