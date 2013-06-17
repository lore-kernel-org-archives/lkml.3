Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3FQImb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:42:31 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55928 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab3FQIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:42:28 -0400
Date: Mon, 17 Jun 2013 09:42:25 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next: manual merge of the arm64-hugepages tree with the
 arm64 tree
Message-ID: <20130617084224.GB28225@linaro.org>
References: <20130617174528.fc0381c10f8c5296b4efe776@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617174528.fc0381c10f8c5296b4efe776@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:45:28PM +1000, Stephen Rothwell wrote:
> Hi Steve,

Hi Stephen,

> 
> Today's linux-next merge of the arm64-hugepages tree got conflicts in
> arch/arm64/include/asm/pgtable-hwdef.h and
> arch/arm64/include/asm/pgtable.h between commit 363116073a26 ("arm64:
> KVM: define HYP and Stage-2 translation page flags") from the arm64 tree
> and commits 072b1b62a643 ("ARM64: mm: Make PAGE_NONE pages read only and
> no-execute") and af07484863e0 ("ARM64: mm: THP support") from the
> arm64-hugepages tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Thanks, the fixup looks good to me.

> Note that the arm64 tree version of PMD_SECT_USER used a pteval_t where I
> would have expected a pmdval_t like the arm64-hugepages tree version.

Yes I think it should be a pmdval_t too, I will follow this up.

Cheers,
-- 
Steve
