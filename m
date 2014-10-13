Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaJMU5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:57:05 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:49139 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753399AbaJMU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:56:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:7652:7903:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat93_76b0b0b82fd0b
X-Filterd-Recvd-Size: 1529
Message-ID: <1413233814.1287.30.camel@joe-AO725>
Subject: Re: [PATCH] Crypto: gf128mul : fixed a parentheses coding style
 issue
From: Joe Perches <joe@perches.com>
To: Michael Roocroft <mike.linux@btinternet.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2014 13:56:54 -0700
In-Reply-To: <543C3BA8.2060709@btinternet.com>
References: <1413146950-932-1-git-send-email-mike.linux@btinternet.com>
	 <1413154885.22149.49.camel@joe-AO725> <543C3229.2090205@btinternet.com>
	 <1413231356.1287.18.camel@joe-AO725> <543C3BA8.2060709@btinternet.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 21:52 +0100, Michael Roocroft wrote:
> I fully intend to making more meaningful contributions
> when my confidence in writing C is better than it is at the moment. I'll concentrate
> on making any changes to staging whilst I learn and get to grips with git, and
> continue to look through the rest of the kernel tree as a learning exercise.

Sounds like a good plan to me.  welcome btw.

> by looking and not doing anything i'll never learn anything.

True words... 

cheers, Joe

