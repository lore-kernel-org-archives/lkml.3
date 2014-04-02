Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433AbaDBVoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:44:23 -0400
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:45359 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933224AbaDBVoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:44:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3874:4321:5007:7652:8603:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13069:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hand86_8a8cc4210039
X-Filterd-Recvd-Size: 1646
Message-ID: <1396475058.32040.10.camel@joe-AO722>
Subject: Re: [PATCH 1/1] AArch64: TCR_TG1_64K incorrectly sets TCR_EL1 bits
 [31:30]
From: Joe Perches <joe@perches.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Joe Sylve <joe.sylve@gmail.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 Apr 2014 14:44:18 -0700
In-Reply-To: <20140402170747.GC24018@arm.com>
References: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
	 <20140402123844.GE31892@arm.com> <20140402170747.GC24018@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 18:07 +0100, Catalin Marinas wrote:
> On Wed, Apr 02, 2014 at 01:38:44PM +0100, Catalin Marinas wrote:
> > On Wed, Apr 02, 2014 at 05:00:38AM +0100, Joe Sylve wrote:
> > > Section D7.2.83 TCR_EL1, Translation Control Register (EL1) of the
> > > latest ARM Architecture Reference Manual, ARMv8, for ARMv8-A states
> > > that TCR_EL1 TG1 (bits [31:30]) should be set to 11 for a 64KB
> > > TTBR1_EL1 granule size. The mainline 3.14 kernel incorrectly sets
> > > those bits to 01 (which is a 16KB granule size).

trivia:

I think the subject title should be arm64


