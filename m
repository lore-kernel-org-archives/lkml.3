Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3KAU1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:27:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3KAU1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:27:45 -0400
Message-ID: <52740EB1.2070901@kernel.dk>
Date: Fri, 01 Nov 2013 14:27:29 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: manual merge of the block tree with the  tree
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>	<5273C473.5070803@kernel.dk> <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
In-Reply-To: <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 02:22 PM, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Fri, 01 Nov 2013 09:10:43 -0600 Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 10/31/2013 09:20 PM, Stephen Rothwell wrote:
>>>
>>> Today's linux-next merge of the block tree got a conflict in
>>> drivers/block/loop.c between commit 2486740b52fd ("loop: use aio to
>>> perform io on the underlying file") from the aio-direct tree and commit
>>> ed2d2f9a8265 ("block: Abstract out bvec iterator") from the block tree.
>>>
>>> I fixed it up (I think - see below - I have also attached the final
>>> resulting file) and can carry the fix as necessary (no action is
>>> required).
>>>
>>
>> What tree is this from? It'd be a lot more convenient to fold that loop
>> patch into my tree, especially since the block tree in linux-next failed
>> after this merge.
> 
> I can only agree with you.  It is from the aio-direct tree (probably
> misnamed by me) (git://github.com/kleikamp/linux-shaggy.git#for-next) run
> by Dave Kleikamp.

Dave, input requested.

In any case, I would suggest dropping the aio-direct tree instead of the
entire block tree for coverage purposes, if merge or build failures
happen because of it.

-- 
Jens Axboe

