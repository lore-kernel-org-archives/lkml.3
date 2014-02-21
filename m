Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaBUVwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:52:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaBUVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:52:08 -0500
Date: Fri, 21 Feb 2014 13:52:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        dhowells <dhowells@redhat.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] afs: afs_alloc_inode: use kmem_cache_zalloc
Message-Id: <20140221135206.665071691c62a8e1863e5a0a@linux-foundation.org>
In-Reply-To: <20140221134716.4a030e668c50e274b6c1a695@linux-foundation.org>
References: <20140220220039.0a727f1bc423339d69ffca0a@skynet.be>
	<20140221134716.4a030e668c50e274b6c1a695@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 13:47:16 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> --- a/fs/afs/super.c~afs-afs_alloc_inode-use-kmem_cache_zalloc-fix
> +++ a/fs/afs/super.c
> @@ -474,7 +474,7 @@ static void afs_i_init_once(void *_vnode
>  }
>  
>  /*
> - * allocate an AFS inode struct from our slab cache
> + * allocate an AFS inode struct
>   */
>  static struct inode *afs_alloc_inode(struct super_block *sb)
>  {

err, this was obviously a product of senility.
