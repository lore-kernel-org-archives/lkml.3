Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaKUJ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:57:30 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40995 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaKUJ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:57:28 -0500
Date: Fri, 21 Nov 2014 01:57:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
In-Reply-To: <546EDBE0.10103@samsung.com>
Message-ID: <alpine.DEB.2.10.1411210156570.32133@chino.kir.corp.google.com>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com> <546DAA99.5070402@samsung.com> <alpine.DEB.2.10.1411201430220.30354@chino.kir.corp.google.com>
 <546EDBE0.10103@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Andrey Ryabinin wrote:

> On 11/21/2014 01:31 AM, David Rientjes wrote:
> > On Thu, 20 Nov 2014, Andrey Ryabinin wrote:
> > 
> >>> Is there a reason to add this for such a specialized purpose to the slab 
> >>> allocator?  I think it can just be handled for struct irq_desc explicitly.
> >>>
> >>
> >> It could be used not only for irq_desc. Grepping sources gave me 7 possible users.
> >>
> > 
> > It would be best to follow in the example of those users and just use 
> > __GFP_ZERO.
> > 
> 
> Fair enough.
> 

Thanks, and feel free to add my

	Acked-by: David Rientjes <rientjes@google.com.

on the other two patches once they are refreshed.
