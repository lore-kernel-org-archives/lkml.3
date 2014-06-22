Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaFVGGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 02:06:22 -0400
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:54869 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750941AbaFVGGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 02:06:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3871:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bear16_1a0bd7cfdd325
X-Filterd-Recvd-Size: 1091
Message-ID: <1403417177.4076.54.camel@joe-AO725>
Subject: Re: [PATCH] fs/ntfs: Use '%lx' instead of '%zx'
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Date: Sat, 21 Jun 2014 23:06:17 -0700
In-Reply-To: <53A649FB.3090808@gmail.com>
References: <53A649FB.3090808@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-22 at 11:14 +0800, Chen Gang wrote:
> For subtraction between 2 pointers, the result's type is 'long', so
> need use '%lx' instead of '%zx'.

result should be a ptrdiff_t so please use %tx



