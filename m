Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3JKMTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:19:37 -0400
Received: from verein.lst.de ([213.95.11.211]:35624 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3JKMTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:19:35 -0400
Date: Fri, 11 Oct 2013 14:19:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Message-ID: <20131011121932.GA18146@lst.de>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com> <20131009194658.GA3066@dhcp-26-207.brq.redhat.com> <20131010191714.GA3098@lst.de> <20131010193240.GA17206@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010193240.GA17206@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:32:41PM +0200, Alexander Gordeev wrote:
> I wonder, if blk-mq- prefix should remain?.. This s code seems pretty much
> generic to me.

Seems like nowdays you should just use the percpu-ida allocator directly,
Shaohua Li hast just sent patches to switch blk-mq over to it as well.

