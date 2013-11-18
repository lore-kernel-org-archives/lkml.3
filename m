Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3KRWg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:36:27 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:41236 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751286Ab3KRWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:36:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3872:3873:4321:5007:7652:10004:10400:10450:10455:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:13846:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meat82_1accdd7b72119
X-Filterd-Recvd-Size: 1220
Message-ID: <1384814182.17783.5.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Check for functions without a real
 prototype
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, apw@canonical.com,
        bp@alien8.de
Date: Mon, 18 Nov 2013 14:36:22 -0800
In-Reply-To: <1384813914-11491-1-git-send-email-richard@nod.at>
References: <1384813914-11491-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 23:31 +0100, Richard Weinberger wrote:
> Functions like this one are evil:
> 
> void foo()
> {
> 	...
> }
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> CC: hpa@zytor.com

I won't take simple resubmissions without updating
based on the notes I gave you.

And now, this should be updated to allow --fix use too.

I'll take care of it instead.

