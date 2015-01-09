Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbbAITqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:46:02 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54703 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbAITqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:46:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Robin Murphy <robin.murphy@arm.com>
Cc: will.deacon@arm.com, m.szyprowski@samsung.com, bhelgaas@google.com,
        joro@8bytes.org, gregkh@linuxfoundation.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] dma-mapping: tidy up dma_parms default handling
Date: Fri, 09 Jan 2015 20:45:49 +0100
Message-ID: <2031542.TLqIP3YVGc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
References: <ffdc5455d698d2525f2d126d0adabf9418fd76b1.1418990609.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:9WG52/sdWpl/rJNHANNvxus8OdRWN1W2XAyLJLdyoo4Wfh6VWdP
 YCd0RgaNFY49Zenm4hE3t5/RdiUOrmqY0aVZr1iU3qpqtpi5Y6xjxmGZDdIUY+RQdmJE4kr
 SCKgYJ0rh3HdYPx9zjBFAvKWgKI1CH6w3FU5UM/cwN7iAc6DAOIm7ztCCgqqa6HU368N0/T
 1UKvBwpuqe7mZr3B5paWQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 16:56:03 Robin Murphy wrote:
> 
> This one's a bit tricky to find a home for - I think technically it's 
> probably an IOMMU patch, but then the long-underlying problem doesn't
> seem to have blown up anything until arm64, and my motivation is to
> make bits of Juno work, which seems to nudge it towards arm64/arm-soc
> territory. Could anyone suggest which tree is most appropriate?

I have a set of patches touching various dma-mapping.h related bits
across architectures and in ARM in particular. Your patch fits into
that series, and I guess we could either have it in my asm-generic
tree or in Andrew Morton's mm tree. Possibly also arm-soc for practical
reasons, although it really doesn't belong in there.

	Arnd
