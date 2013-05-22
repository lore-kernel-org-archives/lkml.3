Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3EVJsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:48:23 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:49104 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753055Ab3EVJsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:48:21 -0400
Date: Wed, 22 May 2013 10:47:41 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] dma-mapping: Define dma_{alloc,free}_attrs()
 for all archs
Message-ID: <20130522094741.GE14322@arm.com>
References: <1367290899-10410-1-git-send-email-dhobsong@igel.co.jp>
 <519C2F5D.8000809@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519C2F5D.8000809@igel.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 03:37:17AM +0100, Damian Hobson-Garcia wrote:
> Hello,
> On 2013/04/30 12:01, Damian Hobson-Garcia wrote:
> > Most architectures that define CONFIG_HAVE_DMA=y, have implementations for
> > both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
> > not define CONFIG_HAVE_DMA also have both of these definitions provided by
> > dma-mapping-broken.h.

BTW, shouldn't this be called CONFIG_HAVE_DMA_ATTRS?

> > Provide a default definition for the archs that define CONFIG_HAVE_DMA=y,
> > but have no implementation for dma_{alloc,free}_attrs(). 
> > 
> > As I don't have hardware for any of these systems, the patches are only
> > compile-tested where I could (arm64, s390) and untested for the archs
> > where I couldn't find a readily available prebuilt cross-compiler (c6x, parisc).
> 
> >  arch/arm64/include/asm/dma-mapping.h  |   17 +++++++++++------
> >  arch/c6x/include/asm/dma-mapping.h    |    3 +++
> >  arch/parisc/include/asm/dma-mapping.h |    3 +++
> >  arch/s390/include/asm/dma-mapping.h   |   17 +++++++++++------
> >  4 files changed, 28 insertions(+), 12 deletions(-)
> > 
> 
> Since this series spans several architectures, what would be the best
> way to have this patch series merged?
> Should I resubmit each patch to the mailing list for each architecture
> separately?

I'm happy to take the arm64 patch.

Thanks.

-- 
Catalin
