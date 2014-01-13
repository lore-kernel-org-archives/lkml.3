Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaAMRr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:47:27 -0500
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:45498 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752290AbaAMRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:47:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:2914:3138:3139:3140:3141:3142:3167:3352:3622:3865:3866:3868:3870:3872:3874:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cream56_2337f80452d00
X-Filterd-Recvd-Size: 1801
Message-ID: <1389635241.24849.22.camel@joe-AO722>
Subject: Re: [PATCH 1/2] efi: Fix krealloc defect
From: Joe Perches <joe@perches.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Jan 2014 09:47:21 -0800
In-Reply-To: <20140113140334.GB3256@console-pimps.org>
References: <cover.1388793978.git.joe@perches.com>
	 <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
	 <20140113140334.GB3256@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 14:03 +0000, Matt Fleming wrote:
> On Fri, 03 Jan, at 04:08:47PM, Joe Perches wrote:
> > krealloc should use a temporary pointer for allocations
> > and check the temporary pointer returned against NULL too.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > cc: Matthew Garrett <matthew.garrett@nebula.com>
> > ---
> >  arch/x86/platform/efi/efi.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Thanks Joe, but I've already got the following commit queued up from
> Borislav that addresses this,

Hi Matt.  That's great.

If it's queued up in some tree of yours, should that
tree be included in Stephen Rothwell's -next?

cheers, Joe

