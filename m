Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab3KEFR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:17:59 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47041 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab3KEFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:17:57 -0500
X-Sasl-enc: mPIbL7v8mJzRBxQ1pDMh12HoohWqPH9WuRho4MinjrdA 1383628676
Date: Mon, 4 Nov 2013 21:20:10 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the staging tree with the block tree
Message-ID: <20131105052010.GA14557@kroah.com>
References: <20131105160924.4da55b7e36aa2ab93443fdda@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105160924.4da55b7e36aa2ab93443fdda@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 04:09:24PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/lustre/lustre/llite/lloop.c between commit ed2d2f9a8265
> ("block: Abstract out bvec iterator") from the block tree and commit
> de40d1209898 ("staging: lustre: fix bug with LL_MRF_RETURN in
> loop_make_request") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
