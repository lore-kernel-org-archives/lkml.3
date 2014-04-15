Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaDOIeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:34:00 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:42906 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752298AbaDOIdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:33:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6120:7652:7903:8531:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cause20_792d8c7c2cf32
X-Filterd-Recvd-Size: 1544
Message-ID: <1397550831.16090.15.camel@joe-AO722>
Subject: Re: [RFC PATCH 1/1] prefetch result in 64 bit atomic ops
From: Joe Perches <joe@perches.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 15 Apr 2014 01:33:51 -0700
In-Reply-To: <20140415075220.GC17408@arm.com>
References: <534C2CC2.9050706@gmail.com> <20140415075220.GC17408@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 08:52 +0100, Will Deacon wrote:
> Did you write this patch as a basic port of the arch/arm/ patches I wrote,
> or was it based on performance figures from real hardware?

>From an earlier thread: https://lkml.org/lkml/2014/4/14/547

On Mon, 2014-04-14 at 14:11 -0400, Pranith Kumar wrote:
> On Mon, Apr 14, 2014 at 2:04 PM, Joe Perches <joe@perches.com> wrote:
> > Are there some benchmark comparison results
> > you neglected to attach?
> 
> I was trying to get these ops to be similar to the 32 bit atomic ops which
> all have prefetch. I did not see any reason why we shouldn't do the same
> here. But no, no hard numbers yet.  Send me a dev board please :)


