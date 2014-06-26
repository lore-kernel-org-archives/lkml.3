Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaFZHkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:40:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaFZHkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:40:45 -0400
Date: Thu, 26 Jun 2014 00:40:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v9] NVMe: Convert to blk-mq
Message-ID: <20140626074033.GA26094@infradead.org>
References: <1403651531-24891-1-git-send-email-m@bjorling.me>
 <1403651531-24891-2-git-send-email-m@bjorling.me>
 <20140625113715.GA4525@infradead.org>
 <CAOu_J6nTcEjEpAe+S7Wg9SxUj_u=QitsDjYkKmCpaGP1MAexhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOu_J6nTcEjEpAe+S7Wg9SxUj_u=QitsDjYkKmCpaGP1MAexhw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:56:35PM +0200, Matias Bj??rling wrote:
> Only the review. Do you want me to change it to a Reviewed-by?


I've not really don't a formal review of the latest patch yet.  I plan
to do it, and will give me Reviewed-by-tag then.  For now I don't think
I'm actually significant enough to be mentioned in the patch.

If you need to fill the patch description some details on the conversion
and performance numbers might be useful :)

