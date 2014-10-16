Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaJPCDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 22:03:09 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:50274 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751298AbaJPCDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 22:03:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:2915:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3873:4321:5007:6261:7903:9010:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: party44_8f57a04428c48
X-Filterd-Recvd-Size: 1408
Message-ID: <1413424983.7484.21.camel@perches.com>
Subject: Re: [PATCH] Change for codestyle and good read
From: Joe Perches <joe@perches.com>
To: Albino Biasutti Neto <bino@riseup.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 19:03:03 -0700
In-Reply-To: <CA+bYFQZrdVaSUpzfPnhaVL_JorZt6fLO+ObqxgQKd3k8OWfi8Q@mail.gmail.com>
References: <1413414942-5338-1-git-send-email-bino@riseup.net>
	 <1413415606.7484.19.camel@perches.com>
	 <CA+bYFQZrdVaSUpzfPnhaVL_JorZt6fLO+ObqxgQKd3k8OWfi8Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 22:55 -0300, Albino Biasutti Neto wrote:
> I'm writing my first kernel patch, sorry. I will be better in the next.

Please experiment with files in drivers/staging/
before you work on other files.

Even then, verify what you do by using tools
like scripts/objdiff and scripts/checkpatch.pl
before you send a patch to the mailing list or
to a maintainer.

Also use scripts/get_maintainer.pl to help
figure out who should be a patch email recipient.



