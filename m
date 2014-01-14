Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaANCfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:35:18 -0500
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:50735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbaANCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:35:15 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3350:3622:3866:3868:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12050:12517:12519:12555:12740:13069:13311:13357:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boats48_846ce630bd445
X-Filterd-Recvd-Size: 1672
Message-ID: <1389666908.24849.29.camel@joe-AO722>
Subject: Re: [PATCH 1/2] efi: Fix krealloc defect
From: Joe Perches <joe@perches.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Jan 2014 18:35:08 -0800
In-Reply-To: <20140113191725.GK3256@console-pimps.org>
References: <cover.1388793978.git.joe@perches.com>
	 <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
	 <20140113140334.GB3256@console-pimps.org>
	 <1389635241.24849.22.camel@joe-AO722>
	 <20140113191725.GK3256@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 19:17 +0000, Matt Fleming wrote:
> On Mon, 13 Jan, at 09:47:21AM, Joe Perches wrote:
> > If it's queued up in some tree of yours, should that
> > tree be included in Stephen Rothwell's -next?
> My trees get pulled into tip and those are included in linux-next. So,
> Borislav's patch is commit ee4114302770 ("x86/efi: Check krealloc return
> value") in today's linux-next.

You're right, thanks.
I thought I did this against -next but it appears not.

cheers, Joe

