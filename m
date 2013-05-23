Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3EWJry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:47:54 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:48757 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757890Ab3EWJrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:47:52 -0400
Date: Thu, 23 May 2013 10:47:09 +0100
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
Message-ID: <20130523094709.GB16722@arm.com>
References: <1367290899-10410-1-git-send-email-dhobsong@igel.co.jp>
 <519C2F5D.8000809@igel.co.jp>
 <20130522094741.GE14322@arm.com>
 <519D8331.3060203@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519D8331.3060203@igel.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 03:47:13AM +0100, Damian Hobson-Garcia wrote:
> Hi Catalin,
> On 2013/05/22 18:47, Catalin Marinas wrote:
> > On Wed, May 22, 2013 at 03:37:17AM +0100, Damian Hobson-Garcia wrote:
> >> Hello,
> >> On 2013/04/30 12:01, Damian Hobson-Garcia wrote:
> >>> Most architectures that define CONFIG_HAVE_DMA=y, have implementations for
> >>> both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
> >>> not define CONFIG_HAVE_DMA also have both of these definitions provided by
> >>> dma-mapping-broken.h.
> > 
> > BTW, shouldn't this be called CONFIG_HAVE_DMA_ATTRS?
> 
> CONFIG_HAVE_DMA_ATTRS is currently used to enable the functions to
> set/get the DMA attribute values. Poking through the headers, it looks
> like the struct dma_attrs is defined regardless of the
> CONFIG_HAVE_DMA_ATTRS setting, so in that respect
> we always seem to "have" DMA attributes (if we have DMA), but they may
> not always be meaningful (ie. set to some value).

My point was about the commit log - grep'ing the kernel for
CONFIG_HAVE_DMA did not return anything.

-- 
Catalin
