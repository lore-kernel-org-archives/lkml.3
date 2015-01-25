Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbbAYNfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:35:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbbAYNfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:35:14 -0500
Date: Sun, 25 Jan 2015 05:35:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH v2 3/4] block: loop: introduce 'use_aio' sysfs file
Message-ID: <20150125133514.GC19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
 <1421163888-21452-4-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421163888-21452-4-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:44:47PM +0800, Ming Lei wrote:
> So that users can control if kernel aio is used to submit I/O.

Why do you want a sysfs flag for this instead of a flags in ->lo_flags
at setup time?  That's how all other loop-related ABI flags work.

