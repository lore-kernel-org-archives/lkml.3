Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3JXJvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:51:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3JXJvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:51:47 -0400
Date: Thu, 24 Oct 2013 02:51:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/11] blk-mq: new multi-queue block IO queueing mechanism
Message-ID: <20131024095147.GA22552@infradead.org>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-11-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-11-git-send-email-axboe@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking forward to get this in and have a reasonale API for modern
block drivers instead of using the bio API.

Acked-by: Christoph Hellwig <hch@lst.de>


