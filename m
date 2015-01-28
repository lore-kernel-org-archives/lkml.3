Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbbA1VS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:18:27 -0500
Received: from verein.lst.de ([213.95.11.211]:34484 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762182AbbA1Uu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:28 -0500
Date: Wed, 28 Jan 2015 18:11:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: manual merge of the block tree with the vfs tree
Message-ID: <20150128171102.GC17528@lst.de>
References: <20150127145754.03e711a3@canb.auug.org.au> <54C70D52.6030208@kernel.dk> <20150127045422.GY29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127045422.GY29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 04:54:22AM +0000, Al Viro wrote:
> I don't mind opening a never-rebased branch for generic iov_iter-related stuff;
> if you prefer to handle it that way - just tell.  The first two patches
> from that series would definitely go there; as for the rest... no preferences
> here.

It might make sense to just keep the VFS patches in your tree.
The target ones also are something I'd prefer if it goes through Nic
with additional review.  In addition they aren't really critical,
so if you merge the prep patches now we can feed the rest through
the proper trees in the .21 merge window.
