Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaFDQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:33:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaFDQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:33:36 -0400
Date: Wed, 4 Jun 2014 09:33:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        Shaohua Li <shli@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604163334.GA21501@infradead.org>
References: <538F331F.60101@kernel.dk>
 <20140604145803.GA7826@infradead.org>
 <538F34FB.7050003@kernel.dk>
 <20140604153159.GA27096@infradead.org>
 <CACVXFVNNTPrq29eS9GzJDequtFXCTNWPLJfzB4Z-XJVE5j8+aA@mail.gmail.com>
 <538F3FB5.2020102@kernel.dk>
 <CACVXFVM-aJwBgrvgT-nNbbi81vE4qeS1LgsS5cFGiz5cbsApZw@mail.gmail.com>
 <538F44AD.4090906@kernel.dk>
 <CACVXFVOxx973ho9yN0W95YCj2XQBoYqyu4aD4bZ_9Pv89XGgnQ@mail.gmail.com>
 <538F4938.7040309@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F4938.7040309@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:28:40AM -0600, Jens Axboe wrote:
> > Attachment patch should be enough.
> 
> Yep, looks fine. Care to send as a proper patch, then I will include it?

I think we an also drop the assignment to q->flush_rq->cmd_flags in
flush_end_io now.

