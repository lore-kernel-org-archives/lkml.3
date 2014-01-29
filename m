Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865AbaA2FCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:02:42 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61585 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaA2FCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:02:40 -0500
Date: Tue, 28 Jan 2014 21:02:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] mm: sl[uo]b: fix misleading comments
In-Reply-To: <20140128222450.0B32C3FD@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1401282102240.20167@chino.kir.corp.google.com>
References: <20140128222450.0B32C3FD@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Dave Hansen wrote:

> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> On x86, SLUB creates and handles <=8192-byte allocations internally.
> It passes larger ones up to the allocator.  Saying "up to order 2" is,
> at best, ambiguous.  Is that order-1?  Or (order-2 bytes)?  Make
> it more clear.
> 
> SLOB commits a similar sin.  It *handles* page-size requests, but the
> comment says that it passes up "all page size and larger requests".
> 
> SLOB also swaps around the order of the very-similarly-named
> KMALLOC_SHIFT_HIGH and KMALLOC_SHIFT_MAX #defines.  Make it
> consistent with the order of the other two allocators.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
