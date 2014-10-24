Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaJXJZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:25:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJXJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:25:06 -0400
Date: Fri, 24 Oct 2014 02:25:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: fix memory leak with scsi-mq
Message-ID: <20141024092505.GA28925@infradead.org>
References: <5449529D.5070804@cybernetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5449529D.5070804@cybernetics.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:10:21PM -0400, Tony Battersby wrote:
> Fix a memory leak with scsi-mq triggered by commands with large data
> transfer length.

Thanks, this was indeed caused by a last minute change due to someone
complaining about my earlier version being a little too convoluted.

Thanks for tracking this down!
