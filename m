Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890AbaKNB0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:26:49 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:46135 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933754AbaKNB0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:26:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3867:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6120:6261:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes60_398ad83fb041f
X-Filterd-Recvd-Size: 2272
Message-ID: <1415928394.4141.3.camel@perches.com>
Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 13 Nov 2014 17:26:34 -0800
In-Reply-To: <20141114011832.GE4042@n2100.arm.linux.org.uk>
References: <20141030120127.GC32589@arm.com>
	 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
	 <20141030135749.GE32589@arm.com>
	 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
	 <20141113235322.GC4042@n2100.arm.linux.org.uk>
	 <1415923530.4223.17.camel@perches.com>
	 <20141114001720.GD4042@n2100.arm.linux.org.uk>
	 <1415925943.4141.1.camel@perches.com>
	 <20141114011832.GE4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 01:18 +0000, Russell King - ARM Linux wrote:
> On Thu, Nov 13, 2014 at 04:45:43PM -0800, Joe Perches wrote:
> > I think you shouldn't apply these patches or updated
> > ones either until all the current uses are converted.
> 
> Where are the dependencies mentioned?

I mentioned it when these patches (which are not
mine btw), were submitted the second time.

https://lkml.org/lkml/2014/10/27/69

> How do I get to know when all
> the dependencies are met?

No idea.

> Who is tracking the dependencies?

Not me.

