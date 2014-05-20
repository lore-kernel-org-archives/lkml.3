Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaETQOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:14:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35615 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754002AbaETQOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:14:18 -0400
Date: Tue, 20 May 2014 17:14:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140520161403.GA28293@arm.com>
References: <1364507176.1345.45.camel@x61.thuisdomein>
 <8309592.drxAj71PnZ@wuerfel>
 <1400059550.31197.12.camel@x220>
 <4305975.PvMXZQ020k@wuerfel>
 <1400232598.20342.16.camel@x220>
 <20140516125545.GO3693@n2100.arm.linux.org.uk>
 <20140517092337.GA67711@MacBook-Pro.local>
 <20140520164819.63357114@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520164819.63357114@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 04:48:19PM +0100, One Thousand Gnomes wrote:
> > old features. Let's say in 10 years time we remove everything ARMv4,
> > another 10 years ARMv5 and so on. We could make these milestones shorter
> > but it really depends on what people use, we should not force them out
> > of the kernel if still in use.
> 
> Why do you care ?

For now, just some negative diffstats in the arm tree ;). Longer term,
supporting only ARMv6+ could bring further core arm code clean-up but
that's not planned for another ~20 years.

> Worry about it at the point nobody can remember needing
> the support, or when it creates some horrible situation that is painful
> to keep supporting and nobody seems to care. We've only recently dropped
> 80386 support, and we still support MC68000.

It's not necessarily how far back we go but rather the wide variation in
ARM processors implementation, especially for the older architecture
versions, and not knowing whether the code still works since no-one
seems to remember having such hardware.

> Or just wait until 2038 approaches and the 32bit panic stations begins,
> then clean out 8)

This kind of matches my proposal to remove ARMv5 support in 20 years
(though we still keep ARMv6 and ARMv7 with 32-bit).

Anyway, the feedback seems to be that we keep them around until they can
no longer be supported (which probably means compiled).

-- 
Catalin
