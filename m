Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbaGXN5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:57:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59952 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759194AbaGXN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:56:59 -0400
Date: Thu, 24 Jul 2014 14:56:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv4 0/5] Atomic pool for arm64
Message-ID: <20140724135640.GD13371@arm.com>
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 02:35:03AM +0100, Laura Abbott wrote:
> Laura Abbott (5):
>   lib/genalloc.c: Add power aligned algorithm
>   lib/genalloc.c: Add genpool range check function
>   common: dma-mapping: Introduce common remapping functions
>   arm: use genalloc for the atomic pool
>   arm64: Add atomic pool for non-coherent and CMA allocations.

The only thing left is the removal of unmap_kernel_range() call in
dma_common_free_remap() (vunmap is enough). Feel free to add my review
to the whole series:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.

-- 
Catalin
