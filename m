Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3IXO3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:29:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IXO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:29:39 -0400
Date: Tue, 24 Sep 2013 07:29:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        axboe@kernel.dk, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/22] Immutable biovecs, block layer changes
Message-ID: <20130924142935.GA5697@infradead.org>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <20130808150954.GA30092@infradead.org>
 <20130808211529.GB15409@kmo-pixel>
 <20130924110012.GA7160@infradead.org>
 <20130924132014.GA16165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924132014.GA16165@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:20:14AM -0400, Mike Snitzer wrote:
> Have you been over the patchset?  Looks sane to you?

I looked over it, although I didn't dig into the details of all driver
patches, and I like what I see.  As said in the previous mail I'd love
to see the patches to shrink struct bio again, too.

> Given how disruptive this patchset is to the block layer I'm wondering
> how painful this change will be in combination with Jens' blk-mq
> changes.  I'd prefer to see blk-mq before immutable biovecs; but I have
> my own selfish reasons for that.

I don't see too much conflicts with blk-multiqueue as that is operating
at the request layer.  Blk-multiqueue defintively is a higher priority
for me, but as it already looks fairly good I have no idea what we're
blocked on for it anyway.

