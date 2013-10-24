Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3JXJkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:40:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3JXJkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:40:02 -0400
Date: Thu, 24 Oct 2013 02:40:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/11] block: make rq->cmd_flags be 64-bit
Message-ID: <20131024094002.GB9433@infradead.org>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-4-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-4-git-send-email-axboe@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:25:56AM +0100, Jens Axboe wrote:
> We have officially run out of flags in a 32-bit space. Extend it
> to 64-bit even on 32-bit archs.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
