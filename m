Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaFYLhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:37:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaFYLhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:37:23 -0400
Date: Wed, 25 Jun 2014 04:37:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org, rlnelson@google.com,
        tom.leiming@gmail.com
Subject: Re: [PATCH v9] NVMe: Convert to blk-mq
Message-ID: <20140625113715.GA4525@infradead.org>
References: <1403651531-24891-1-git-send-email-m@bjorling.me>
 <1403651531-24891-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403651531-24891-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 01:12:11AM +0200, Matias Bj??rling wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.
> 
> Contributions in this patch from:
> 
>   Sam Bradshaw <sbradshaw@micron.com>
>   Jens Axboe <axboe@kernel.dk>
>   Keith Busch <keith.busch@intel.com>
>   Christoph Hellwig <hch@infradead.org>
>   Robert Nelson <rlnelson@google.com>

Is there really something from me in here except for a bit of review?

