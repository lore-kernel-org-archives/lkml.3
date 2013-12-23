Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3LWQ1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:27:11 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3LWQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:27:08 -0500
Date: Mon, 23 Dec 2013 08:27:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] block: blk-mq: don't export blk_mq_free_queue()
Message-ID: <20131223162707.GD9383@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
 <1387815539-12257-5-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815539-12257-5-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah sorry, should have read this one earlier.

