Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbbAXA2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:28:04 -0500
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:39800 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbbAXA2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:28:02 -0500
Date: Fri, 23 Jan 2015 18:28:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@kernel.org,
        iamjoonsoo@lge.com, Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [RFC 0/3] Slab allocator array operations
In-Reply-To: <20150123145734.aa3c6c6e7432bc3534f2c4cc@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1501231827330.10083@gentwo.org>
References: <20150123213727.142554068@linux.com> <20150123145734.aa3c6c6e7432bc3534f2c4cc@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Andrew Morton wrote:

> On Fri, 23 Jan 2015 15:37:27 -0600 Christoph Lameter <cl@linux.com> wrote:
>
> > Attached a series of 3 patches to implement functionality to allocate
> > arrays of pointers to slab objects. This can be used by the slab
> > allocators to offer more optimized allocation and free paths.
>
> What's the driver for this?  The networking people, I think?  If so,
> some discussion about that would be useful: who is involved, why they
> have this need, who are the people we need to bug to get it tested,
> whether this implementation is found adequate, etc.

Jesper and I gave a talk at LCA about this. LWN has an article on it.

