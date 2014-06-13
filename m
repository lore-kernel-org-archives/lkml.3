Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaFMN4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:56:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:26651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFMNz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:55:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,471,1400050800"; 
   d="scan'208";a="445204228"
Date: Fri, 13 Jun 2014 09:55:52 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matias Bj??rling <m@bjorling.me>, keith.busch@intel.com,
        sbradshaw@micron.com, axboe@fb.com, tom.leiming@gmail.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v8] convert nvme driver to blk-mq
Message-ID: <20140613135552.GC12025@linux.intel.com>
References: <1402661396-19207-1-git-send-email-m@bjorling.me>
 <20140613132704.GA26689@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613132704.GA26689@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 06:27:04AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 13, 2014 at 02:09:55PM +0200, Matias Bj??rling wrote:
> > Matthew master up to:
> > 
> >   bd67608a6127c994e897c49cc4f72d9095925301
> >   NVMe: Rename io_timeout to nvme_io_timeout
> 
> Willy, is do you plan to send these updates to Linus for 3.16?

The ones in my tree, yes.  Matias' mq conversion, no.
