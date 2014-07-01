Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaGAINQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:13:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaGAINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:13:12 -0400
Date: Tue, 1 Jul 2014 01:13:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] block: virtio-blk: support multi vq per virtio-blk
Message-ID: <20140701081311.GA21973@infradead.org>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
 <CACVXFVMHPdEzai32jRmLt7qGMFcUqFb8OunF0tzySpKoLWWiwQ@mail.gmail.com>
 <CACVXFVMb4UXRYSp6nvjDQrDRcLP6rJ3_3QHYMzKv9MoogsU66w@mail.gmail.com>
 <53B22473.8010709@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B22473.8010709@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:01:07PM -0600, Jens Axboe wrote:
> >I appreciate very much that one of you may queue these two
> >patches into your tree so that userspace work can be kicked off,
> >since Michael has acked both patches and all comments have
> >been addressed already.
> 
> Given that Michael also acked it and Rusty is on his sabbatical, I'll queue
> it up for 3.17.

So Rusty is offline?  Who is taking care of module/moduleparam patches
in the meantime?

