Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaLYSG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 13:06:28 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:43181 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752224AbaLYSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 13:06:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3873:4321:4419:4605:5007:6261:7514:9149:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: angle87_7241fc8cb0b52
X-Filterd-Recvd-Size: 1377
Message-ID: <1419530782.6157.15.camel@perches.com>
Subject: Re: [PATCH] staging: skein: Fix checkpatch warnings
From: Joe Perches <joe@perches.com>
To: arno.tiemersma@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 25 Dec 2014 10:06:22 -0800
In-Reply-To: <1419530490-32316-1-git-send-email-arno.tiemersma@gmail.com>
References: <1419530490-32316-1-git-send-email-arno.tiemersma@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-25 at 19:01 +0100, arno.tiemersma@gmail.com wrote:
> Remove do {} while (0) loops around single statements in
> skein/skein_block.c
[]
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
[]
> @@ -83,9 +83,7 @@ do {                                                                      \
>  #else
>  /* looping version */
>  #define R256(p0, p1, p2, p3, ROT, r_num) \
> -do { \
>  	ROUND256(p0, p1, p2, p3, ROT, r_num); \

When you do these things, you also have to
remove the trailing semi-colon and the
line continuation '\' as well.


