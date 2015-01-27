Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbbA0EAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:00:25 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49660 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbA0EAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:00:21 -0500
Message-ID: <54C70D52.6030208@kernel.dk>
Date: Mon, 26 Jan 2015 21:00:18 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: manual merge of the block tree with the vfs tree
References: <20150127145754.03e711a3@canb.auug.org.au>
In-Reply-To: <20150127145754.03e711a3@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 08:57 PM, Stephen Rothwell wrote:
> Hi Jens,
>
> Today's linux-next merge of the block tree got a conflict in
> drivers/block/loop.c between commit c2ca80413553 ("loop: convert to
> vfs_iter_read/write") from the vfs tree and commit b5dd2f6047ca
> ("block: loop: improve performance via blk-mq") and several others from
> the block tree.
>
> I have no idea how fixed it up so I just used the version of the file
> from the block tree (its been there a while).  Please have a chat and
> figure out how to combine these two large changes.

Why isn't the loop patch in the block tree? That'd avoid such incidents. 
We could add a dependency for the required VFS patch.


-- 
Jens Axboe

