Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaLPJpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:45:38 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:50501 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaLPJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:45:35 -0500
Date: Tue, 16 Dec 2014 09:45:27 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Elliott <elliott@hp.com>, Matt Wagantall <mattw@codeaurora.org>
Subject: Re: [PATCH v10] iopoll: Introduce memory-mapped IO polling macros
Message-ID: <20141216094527.GC6580@arm.com>
References: <1418687243-16395-1-git-send-email-mitchelh@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418687243-16395-1-git-send-email-mitchelh@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:47:23PM +0000, Mitchel Humpherys wrote:
> From: Matt Wagantall <mattw@codeaurora.org>
> 
> It is sometimes necessary to poll a memory-mapped register until its value
> satisfies some condition. Introduce a family of convenience macros that do
> this. Tight-looping, sleeping, and timing out can all be accomplished using
> these macros.
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Robert Elliott <elliott@hp.com>
> Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
> Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
> ---
> v9..10:
>   - Actually added the comments mentioned in v8..v9 (doh!)
> 
> v8..v9:
>   - Added note in comments about max sleep time (Rob Elliott)
> 
> v7..v8:
>   - sorted helper macros by size (b, w, l, q)
>   - removed some of the more esoteric (or flat-out bogus) helper macros
> 
> This patch was originally part of a series [1] for adding support for IOMMU
> address translations through an ARM SMMU hardware register.  The other
> patch in the series (the one that actually uses these macros and implements
> said hardware address translations) was Ack'd by the driver maintainer
> there (Will Deacon) so I've pulled this patch out to avoid resending an
> already Ack'd patch over and over again.
> 
> In short, please see [1] for previous discussion and the first user of
> these macros.
> 
> Will also acked this patch in [2].  I didn't retain his Ack here because I
> added to the macro comments.

You can keep the ack, it still looks good to me and I'm not really fussed
about the comments.

Will
