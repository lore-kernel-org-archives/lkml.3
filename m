Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbaGOLKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:10:33 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:36112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758752AbaGOLKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:10:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3876:3877:4321:5007:6114:6642:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skirt65_59d299842fb11
X-Filterd-Recvd-Size: 1394
Message-ID: <1405422615.14773.1.camel@joe-AO725>
Subject: Re: [PATCH v2 27/29] MAINTAINERS: Add nios2 maintainer
From: Joe Perches <joe@perches.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Date: Tue, 15 Jul 2014 04:10:15 -0700
In-Reply-To: <1405413956-2772-28-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	 <1405413956-2772-28-git-send-email-lftan@altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 16:45 +0800, Ley Foon Tan wrote:
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

trivia:

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -6350,6 +6350,13 @@ S:	Maintained
[]
> +NIOS2 ARCHITECTURE
> +M:	Ley Foon Tan <lftan@altera.com>
> +L:	nios2-dev@lists.rocketboards.org (moderated for non-subscribers)
> +T:	git://git.rocketboards.org/linux-socfpga.git

this should be:
T:	git git://git.rocketboards.org/linux-socfpga.git


