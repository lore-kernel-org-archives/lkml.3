Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaEIFvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 01:51:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaEIFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 01:51:07 -0400
Date: Thu, 8 May 2014 22:51:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>, Selvan Mani <smani@micron.com>
Subject: Re: mtip32xx: add open/close handlers in block device ops
Message-ID: <20140509055105.GA572@infradead.org>
References: <536BFC2E.10404@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BFC2E.10404@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 02:50:38PM -0700, Asai Thambi S P wrote:
> 
> Add open/close handlers to 'block_device_operations' instance.

There is no point in adding dead code like this.
