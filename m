Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaBSR2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:28:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbaBSR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:28:07 -0500
Date: Wed, 19 Feb 2014 09:28:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch]blk-mq: remove obsolete comments
Message-ID: <20140219172805.GA14338@infradead.org>
References: <20140219122222.GB17818@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219122222.GB17818@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 08:22:22PM +0800, Shaohua Li wrote:
> 
> We now have blk_mq_stop/start_queues API, delete the obsolete comments.

We do have the API, but the big question is if we want to require every
driver to manually call it each time we get a busy return here.

