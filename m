Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbbA0R7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:59:54 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbA0R7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:59:52 -0500
Date: Tue, 27 Jan 2015 09:59:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "open list:AIO" <linux-aio@kvack.org>
Subject: Re: [PATCH v2 1/4] aio: add aio_kernel_() interface
Message-ID: <20150127175951.GA6886@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
 <1421163888-21452-2-git-send-email-ming.lei@canonical.com>
 <20150125133147.GA19445@infradead.org>
 <CACVXFVOzjroTqcgduqvKzcDVvNvO4xGX6go3+ZspfQkz3_2zAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOzjroTqcgduqvKzcDVvNvO4xGX6go3+ZspfQkz3_2zAQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:18:23AM +0800, Ming Lei wrote:
> > Why do we keep these two separate?  Especially having the iov passed
> 
> No special meaning, just follow previous patches, :-)
> 
> But one benefit is that we can separate the one-shot
> initialization from submit, at least filep/complete/ki_ctx can be
> set during initialization.

FYI, I've posted another approach at async kernel reads/writes in the
"[RFC] split struct kiocb" series.  I thought I had you on Cc, but I
messed it up.

This keeps the separate init function, but it still feels a bit
pointless to me.

