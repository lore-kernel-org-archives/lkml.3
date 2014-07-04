Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbaGDCpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:45:06 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:44491 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752012AbaGDCpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:45:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2551:2553:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3874:4321:4605:5007:7576:7652:10004:10400:10848:11658:11914:12043:12050:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toad74_8310fdb75863e
X-Filterd-Recvd-Size: 2391
Message-ID: <1404441898.6384.7.camel@joe-AO725>
Subject: Re: FW: [PATCH 04/16] MAINTAINERS: Update clk/sirf patterns
From: Joe Perches <joe@perches.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Date: Thu, 03 Jul 2014 19:44:58 -0700
In-Reply-To: <CAGsJ_4wkWcczu=EN=ZeKCS_++D2aH3nWxdC_oion+j6au=idCA@mail.gmail.com>
References: <cover.1404425176.git.joe@perches.com>
	 <32eedc96dfe8761925d0663e50cd29aaac32e9af.1404425176.git.joe@perches.com>
	 <5EB3BFCD089AD643B9BB63439F5FD5E9012BF6F220@SHAASIEXM01.ASIA.ROOT.PRI>
	 <CAGsJ_4wkWcczu=EN=ZeKCS_++D2aH3nWxdC_oion+j6au=idCA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 09:33 +0800, Barry Song wrote:
> >> -----Original Message-----
> >> From: Joe Perches [mailto:joe@perches.com]
> >> Sent: Friday, July 04, 2014 6:08 AM
[]
> >> commit 7bf21bc81f28 ("clk: sirf: re-arch to make the codes support both
> >> prima2 and atlas6") moved the files, update the patterns.
[]
> >> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> >> @@ -894,7 +894,7 @@ L:        linux-arm-kernel@lists.infradead.org
> >> (moderated for non-subscribers)
> >>  T:   git git://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git
> >>  S:   Maintained
> >>  F:   arch/arm/mach-prima2/
> >> -F:   drivers/clk/clk-prima2.c
> >> +F:   drivers/clk/sirf/
> 
> has "N:   [^a-z]sirf" included this?

Kinda.  From MAINTAINERS:

	N: Files and directories with regex patterns.
	   N:	[^a-z]tegra	all files whose path contains the word tegra
	   One pattern per line.  Multiple N: lines acceptable.
	   scripts/get_maintainer.pl has different behavior for files that
	   match F: pattern and matches of N: patterns.  By default,
	   get_maintainer will not look at git log history when an F: pattern
	   match occurs.  When an N: match occurs, git log history is used
	   to also notify the people that have git commit signatures.


