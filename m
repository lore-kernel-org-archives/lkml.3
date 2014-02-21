Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaBUWsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaBUWsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:48:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140221135206.665071691c62a8e1863e5a0a@linux-foundation.org>
References: <20140221135206.665071691c62a8e1863e5a0a@linux-foundation.org> <20140220220039.0a727f1bc423339d69ffca0a@skynet.be> <20140221134716.4a030e668c50e274b6c1a695@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] afs: afs_alloc_inode: use kmem_cache_zalloc
Date: Fri, 21 Feb 2014 22:48:16 +0000
Message-ID: <22313.1393022896@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > - * allocate an AFS inode struct from our slab cache
> > + * allocate an AFS inode struct
> >   */
> >  static struct inode *afs_alloc_inode(struct super_block *sb)
> >  {
> 
> err, this was obviously a product of senility.

My comment, or your comment on my comment?

David
