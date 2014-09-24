Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaIXOyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:54:46 -0400
Received: from verein.lst.de ([213.95.11.211]:53754 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaIXOyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:54:44 -0400
Date: Wed, 24 Sep 2014 16:54:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] block: remove blk_init_flush() and its pair
Message-ID: <20140924145441.GA9713@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-7-git-send-email-ming.lei@canonical.com> <20140924102012.GB19078@lst.de> <CACVXFVMv-mb8LJuJHMJA-3LWYHhV3Cki6fc+_OK3kzXXB2WXnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMv-mb8LJuJHMJA-3LWYHhV3Cki6fc+_OK3kzXXB2WXnA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:49:00PM +0800, Ming Lei wrote:
> Simpler to merge, but more difficult to split. It is for easier review,
> since patch 5 is a bit big and each patch still does one thing.

I defintively find the current version hard to review - it moves
code around a few times before it setlles, so it requires a lot of
memory or applying patches one after another to a tree.  And while
this might be useful in some cases this is one where merging the
patches doesn't seem to have much of a downside.  We'd still move
various fields into a structure, and add helpers to init it, just
with a tiny bit more changes on the initialization side.

That being said if you really prefer the split that's fine with me,
but it doesn't really seem helpful.
