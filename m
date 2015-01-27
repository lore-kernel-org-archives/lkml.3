Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbbA0Ey3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:54:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42675 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbbA0Ey1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:54:27 -0500
Date: Tue, 27 Jan 2015 04:54:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: manual merge of the block tree with the vfs tree
Message-ID: <20150127045422.GY29656@ZenIV.linux.org.uk>
References: <20150127145754.03e711a3@canb.auug.org.au>
 <54C70D52.6030208@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C70D52.6030208@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:00:18PM -0700, Jens Axboe wrote:
> On 01/26/2015 08:57 PM, Stephen Rothwell wrote:
> >Hi Jens,
> >
> >Today's linux-next merge of the block tree got a conflict in
> >drivers/block/loop.c between commit c2ca80413553 ("loop: convert to
> >vfs_iter_read/write") from the vfs tree and commit b5dd2f6047ca
> >("block: loop: improve performance via blk-mq") and several others from
> >the block tree.
> >
> >I have no idea how fixed it up so I just used the version of the file
> >from the block tree (its been there a while).  Please have a chat and
> >figure out how to combine these two large changes.
> 
> Why isn't the loop patch in the block tree? That'd avoid such
> incidents. We could add a dependency for the required VFS patch.

I don't mind opening a never-rebased branch for generic iov_iter-related stuff;
if you prefer to handle it that way - just tell.  The first two patches
from that series would definitely go there; as for the rest... no preferences
here.
