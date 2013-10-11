Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3JKKpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:45:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48311 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758056Ab3JKKo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:56 -0400
Date: Fri, 11 Oct 2013 11:44:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm64: include: asm: atomic.h: use 'unsigned int'
 and 'atomic_t' instead of 'unsigned long' for atomic_clear_mask()
Message-ID: <20131011104419.GE14732@mudshark.cambridge.arm.com>
References: <52561137.3070608@asianux.com>
 <5256117A.4000009@asianux.com>
 <5256121A.9030504@asianux.com>
 <52561269.60900@asianux.com>
 <20131010100733.GH3817@mudshark.cambridge.arm.com>
 <52568998.2080108@asianux.com>
 <20131010142305.GG6199@mudshark.cambridge.arm.com>
 <525751E2.3020207@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525751E2.3020207@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:18:26AM +0100, Chen Gang wrote:
> On 10/10/2013 10:23 PM, Will Deacon wrote:
> > On Thu, Oct 10, 2013 at 12:03:52PM +0100, Chen Gang wrote:
> >> BTW: do arm64 need atomic_clear_mask()?
> > 
> > No. Neither ARM nor arm64 need this function.
> 
> OK, thank you for your confirmation.
> 
> Hmm... can we remove atomic_clear_mask() from ARM and arm64? (in my
> opinion, if not need, better to remove it).

Yes!

I mentioned this a few times already...

Will
