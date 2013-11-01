Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3KAPK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:10:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53521 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3KAPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:10:58 -0400
Message-ID: <5273C473.5070803@kernel.dk>
Date: Fri, 01 Nov 2013 09:10:43 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: manual merge of the block tree with the  tree
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>
In-Reply-To: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 09:20 PM, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> drivers/block/loop.c between commit 2486740b52fd ("loop: use aio to
> perform io on the underlying file") from the aio-direct tree and commit
> ed2d2f9a8265 ("block: Abstract out bvec iterator") from the block tree.
> 
> I fixed it up (I think - see below - I have also attached the final
> resulting file) and can carry the fix as necessary (no action is
> required).
> 

What tree is this from? It'd be a lot more convenient to fold that loop
patch into my tree, especially since the block tree in linux-next failed
after this merge.

-- 
Jens Axboe

