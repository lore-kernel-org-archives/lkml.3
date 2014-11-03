Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaKCSvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:51:35 -0500
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:60964 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753393AbaKCSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:51:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:3873:3874:4321:5007:6261:7514:7576:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: badge35_6427f7d801d39
X-Filterd-Recvd-Size: 1470
Message-ID: <1415040686.17743.31.camel@perches.com>
Subject: Re: [PATCH] net: eth: realtek: atp: checkpatch errors and warnings
 corrected
From: Joe Perches <joe@perches.com>
To: Roberto Medina <robertoxmed@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 10:51:26 -0800
In-Reply-To: <1415039073-20164-1-git-send-email-robertoxmed@gmail.com>
References: <1415039073-20164-1-git-send-email-robertoxmed@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 19:24 +0100, Roberto Medina wrote:
> From: Roberto Medina <robertoxmed@gmail.com>
> 
> Several warnings and errors corrected using checkpatch.
> Some warnings like "line over 80" are still present.
> 
> Before the patch:
> 	total: 16 errors, 155 warnings, 38 checks, 883 lines checked
> 
> With the patch:
> 	total: 0 errors, 64 warnings, 24 checks, 905 lines checked
> 	
> Compile tested.

Some ancient drivers could be regarded as neolithic
curiosities that never need updating.  This may be one.

But if you really want to change it, could you please
make sure that objdiff shows no changes?


