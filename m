Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3JQSDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:03:00 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:22279 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897Ab3JQSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:02:59 -0400
Date: Thu, 17 Oct 2013 18:02:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@iki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/15] slab: overload struct slab over struct page to
 reduce memory usage
In-Reply-To: <525F8FA4.3000702@iki.fi>
Message-ID: <00000141c795afcd-7cd3594e-91c4-404a-9f99-48c3b7d19d6f-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org> <525F8FA4.3000702@iki.fi>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Pekka Enberg wrote:

> On 10/16/13 10:34 PM, Andrew Morton wrote:
> > On Wed, 16 Oct 2013 17:43:57 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > wrote:
> >
> > > There is two main topics in this patchset. One is to reduce memory usage
> > > and the other is to change a management method of free objects of a slab.
> > >
> > > The SLAB allocate a struct slab for each slab. The size of this structure
> > > except bufctl array is 40 bytes on 64 bits machine. We can reduce memory
> > > waste and cache footprint if we overload struct slab over struct page.
> > Seems a good idea from a quick look.
>
> Indeed.
>
> Christoph, I'd like to pick this up and queue for linux-next. Any
> objections or comments to the patches?

I think this is fine. I have looked through the whole set repeatedly and
like the overall approach but I have I have only commented in detail on a
the beginning part of it. There was always something coming up. Sigh.


