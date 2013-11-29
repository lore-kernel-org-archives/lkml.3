Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3K2UAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:00:19 -0500
Received: from one.firstfloor.org ([193.170.194.197]:38100 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3K2UAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:00:15 -0500
Date: Fri, 29 Nov 2013 21:00:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] x86: enable DMA CMA with swiotlb
Message-ID: <20131129200014.GD17656@two.firstfloor.org>
References: <1385736706-3147-1-git-send-email-akinobu.mita@gmail.com>
 <1385736706-3147-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385736706-3147-2-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This also needs to change .free callback in the dma_map_ops for amd_gart
> and sta2x11, because these dma_ops are also using
> dma_generic_alloc_coherent().

Looks good to me from a quick read.

-Andi

