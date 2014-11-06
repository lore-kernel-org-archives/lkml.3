Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaKFVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:32:15 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:59665 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750706AbaKFVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:32:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3868:3870:3871:3872:4321:4559:4605:5007:6119:6261:7576:7903:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: berry88_4d2f2138c304a
X-Filterd-Recvd-Size: 1635
Message-ID: <1415309523.21965.2.camel@perches.com>
Subject: Re: [PATCH] lib/halfmd4: make build optional
From: Joe Perches <joe@perches.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Aristeu Rozanski <arozansk@redhat.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Triplett <josh@joshtriplett.org>
In-Reply-To: <1415309253-13019-1-git-send-email-aris@redhat.com>
References: <1415309253-13019-1-git-send-email-aris@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 06 Nov 2014 13:32:03 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.12.7-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 16:27 -0500, Aristeu Rozanski wrote:
> From: Aristeu Rozanski <arozansk@redhat.com>
> 
> halfmd4 currently is built unconditionally:
> 	text    data     bss     dec     hex filename
> 	 801     176       8     985     3d9 lib/halfmd4.o
> 	 801     176       8     985     3d9 (TOTALS)
> 
> and it's used by ext3 and ext4. This patch is useful for situations
> in which memory footprint is a concern and those filesystems aren't
> used.
[]
> diff --git a/lib/Kconfig b/lib/Kconfig
[]
> +config HALF_MD4
> +	bool "Half MD4 transform"
> +	default y

why not default n ? (and in the other patch)

