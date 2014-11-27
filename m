Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaK0Hid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:38:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaK0Hia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:38:30 -0500
Date: Wed, 26 Nov 2014 23:38:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: manual merge of the block tree with the ext4 tree
Message-ID: <20141127073826.GA4578@infradead.org>
References: <20141127145347.0083c0bc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127145347.0083c0bc@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:53:47PM +1100, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> fs/fs-writeback.c between commit ef7fdf5e8c87 ("vfs: add support for a
> lazytime mount option")

Mergign that into a branch for linux-next must surely have been a
mistake, as the code isn't anywhere near ready.

I also think it very much should go into through the vfs tree.
