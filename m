Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaE1S5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:57:05 -0400
Received: from fieldses.org ([174.143.236.118]:33141 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbaE1S5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:57:02 -0400
Date: Wed, 28 May 2014 14:57:00 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20140528185700.GC22210@fieldses.org>
References: <20140528120728.2bce9521@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528120728.2bce9521@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:07:28PM +1000, Stephen Rothwell wrote:
> Hi Bruce,
> 
> After merging the nfsd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> 
> fs/nfsd/nfs4xdr.c: In function 'nfsd4_encode_security_label':
> fs/nfsd/nfs4xdr.c:1945:15: error: 'pp' undeclared (first use in this function)
>   __be32 *p = *pp;
>                ^
> 
> Caused by commit 8ea0abf0a992 ("nfsd4: use xdr_reserve_space in
> attribute encoding").

Fixed; thanks again.

> "This is a cosmetic change for now; no change in
> behavior" :-(  They are the ones you have to be very careful of ...

Hah, maybe.

--b.

> I have used the nfsd tree from next-20140523 and for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


