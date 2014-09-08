Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaIHUQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:16:04 -0400
Received: from verein.lst.de ([213.95.11.211]:44809 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaIHUQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:16:02 -0400
Date: Mon, 8 Sep 2014 22:15:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
Message-ID: <20140908201557.GA1378@lst.de>
References: <1410044994-14943-1-git-send-email-hch@lst.de> <20140907114153.GB26569@redhat.com> <20140907184745.GA23026@lst.de> <20140908081830.GA32268@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908081830.GA32268@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:18:30AM +0300, Michael S. Tsirkin wrote:
> Could you respond to Ming Lei's mail, who benchmarked the patch, please?

I don't really have any additional data or disagreement, not sure what
I should respond there.
