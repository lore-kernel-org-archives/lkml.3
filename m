Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaHCGKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 02:10:22 -0400
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:52730 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750791AbaHCGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 02:10:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3872:3873:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime94_1f79e3bfbc905
X-Filterd-Recvd-Size: 1457
Message-ID: <1407046215.1835.24.camel@joe-AO725>
Subject: Re: [PATCH 1/1] cris: fix %d confusingly prefixed with 0x in format
 string
From: Joe Perches <joe@perches.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
        linux-cifs@vger.kernel.org, alsa-devel@alsa-project.org
Date: Sat, 02 Aug 2014 23:10:15 -0700
In-Reply-To: <53DD8E17.1@hanshq.net>
References: <1407018043-648-1-git-send-email-hans@hanshq.net>
	 <1407026806.1835.21.camel@joe-AO725> <53DD8E17.1@hanshq.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-02 at 18:19 -0700, Hans Wennborg wrote:
> Yes, I have a patch for a bunch of these, but I figured it would be 
> easier to get it merged if I split it up. (Complete kernel newbie here.)

You as a kernel newbie did good, thanks.

A small tip would be to do all of them in a single series
cc'ing each individual patch to the appropriate maintainers
and mailing lists.

cheers, Joe

