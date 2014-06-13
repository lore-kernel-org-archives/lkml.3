Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaFMN1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:27:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaFMN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:27:17 -0400
Date: Fri, 13 Jun 2014 06:27:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v8] convert nvme driver to blk-mq
Message-ID: <20140613132704.GA26689@infradead.org>
References: <1402661396-19207-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402661396-19207-1-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 02:09:55PM +0200, Matias Bj??rling wrote:
> Matthew master up to:
> 
>   bd67608a6127c994e897c49cc4f72d9095925301
>   NVMe: Rename io_timeout to nvme_io_timeout

Willy, is do you plan to send these updates to Linus for 3.16?

