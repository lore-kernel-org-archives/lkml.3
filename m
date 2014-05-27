Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaE0VWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:22:08 -0400
Received: from fieldses.org ([174.143.236.118]:60213 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbaE0VWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:22:06 -0400
Date: Tue, 27 May 2014 17:22:04 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20140527212204.GD32160@fieldses.org>
References: <20140526111815.25153c0c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526111815.25153c0c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:18:15AM +1000, Stephen Rothwell wrote:
> Hi Bruce,
> 
> After merging the nfsd tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfsd/nfs4proc.c: In function 'warn_on_nonidempotent_op':
> fs/nfsd/nfs4proc.c:1861:3: error: implicit declaration of function 'nfsd4_op_name' [-Werror=implicit-function-declaration]
>    pr_err("unable to encode reply to nonidempotent op %d (%s)\n",
>    ^
> 
> Caused by commit 4d332a993e64 ("nfsd4: fix encoding of out-of-space replies").
> 
> I have used the nfsd tree from next-20140523 for today.

Thanks for catching that!  It should be fixed.  (But I also pushed out a
bunch of new stuff, so hopefully that didn't introduce anything equally
bad....).

--b.
