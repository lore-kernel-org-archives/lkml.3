Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbbAJCZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:25:35 -0500
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:52237 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753315AbbAJCZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:25:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:4250:4321:5007:6117:6121:6261:8957:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cap80_6a6c23126a01a
X-Filterd-Recvd-Size: 1442
Message-ID: <1420856730.32628.18.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: add git url entry for UIO
From: Joe Perches <joe@perches.com>
To: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, mchehab@osg.samsung.com,
        crope@iki.fi, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Fri, 09 Jan 2015 18:25:30 -0800
In-Reply-To: <1420856011-1491-2-git-send-email-mandeep.sandhu@cyaninc.com>
References: <1420856011-1491-1-git-send-email-mandeep.sandhu@cyaninc.com>
	 <1420856011-1491-2-git-send-email-mandeep.sandhu@cyaninc.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 18:13 -0800, Mandeep Sandhu wrote:
> Added git url for UIO section.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -10149,6 +10149,7 @@ S:	Maintained
>  F:	Documentation/DocBook/uio-howto.tmpl
>  F:	drivers/uio/
>  F:	include/linux/uio*.h
> +T:	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git

Please add a "git" prefix type and move
this line before the F: entries.

T:	git git://git.kernel.org/etc...


