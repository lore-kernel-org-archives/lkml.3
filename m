Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbbA0Pmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:42:47 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:44066 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273AbbA0Pmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:42:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2917:3138:3139:3140:3141:3142:3622:3865:3866:3872:4321:4384:5007:6261:7875:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crowd59_33fcb024e0a0e
X-Filterd-Recvd-Size: 1756
Message-ID: <1422373354.18650.8.camel@perches.com>
Subject: Re: [PATCH 11/18] spi/xilinx: Remove rx_fn and tx_fn pointer
From: Joe Perches <joe@perches.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Tue, 27 Jan 2015 07:42:34 -0800
In-Reply-To: <CAPybu_3gF1BXhq4j5Z3DfM8_PxuK72Pshm6_5qVKH-ZyYTpgig@mail.gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1422029330-10971-12-git-send-email-ricardo.ribalda@gmail.com>
	 <20150127000903.GM21293@sirena.org.uk>
	 <CAPybu_3gF1BXhq4j5Z3DfM8_PxuK72Pshm6_5qVKH-ZyYTpgig@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 11:00 +0100, Ricardo Ribalda Delgado wrote:
> >> +     xspi->rx_ptr += xspi->bits_per_word/8;
> > Also there's
> > a coding style thing - spaces around the / please.
[]
> I am also cc: the maintainers of checkpatch, because for whatever
> reason, this was not found by the script

Because it's personal preference.

checkpatch would note if a space was used
inconsistently (before but not after the /,
or the other way 'round)


