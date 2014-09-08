Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaIHSsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:48:40 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:49704 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754471AbaIHSsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:48:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3872:3874:4321:5007:6119:7652:7903:9010:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun61_10d63a7e02359
X-Filterd-Recvd-Size: 1428
Message-ID: <1410202114.12560.16.camel@joe-AO725>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Date: Mon, 08 Sep 2014 11:48:34 -0700
In-Reply-To: <20140908181524.GA11839@www.outflux.net>
References: <20140908181524.GA11839@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 11:15 -0700, Kees Cook wrote:
> Check for misspellings, based on Debian's lintian list. Several false
> positives were removed, and several additional words added that were
> common in the kernel:
> 
> 	backword backwords
> 	invalide valide
> 	recieves
> 	singed unsinged
> 
> While going back and fixing existing spelling mistakes isn't a high
> priority, it'd be nice to try to catch them before they hit the tree.

Seems sensible enough.

Acked-by: Joe Perches <joe@perches.com>


