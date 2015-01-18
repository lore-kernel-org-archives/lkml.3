Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbARPLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:11:20 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbARPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:11:18 -0500
Date: Sun, 18 Jan 2015 07:10:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Tony Luck <tony.luck@gmail.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4 v4] brd: Fix all partitions BUGs
Message-ID: <20150118151059.GA17263@infradead.org>
References: <54AD5893.9040701@plexistor.com>
 <54AD59DC.4020703@plexistor.com>
 <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com>
 <54B99591.7080007@fb.com>
 <54BBB048.7010207@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BBB048.7010207@plexistor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we just get rid of the warnings?  It's fairly annoying as devices
without partitions are perfectly fine and very useful.

