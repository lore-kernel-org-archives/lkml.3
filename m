Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaFDRvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:51:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaFDRvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:51:40 -0400
Date: Wed, 4 Jun 2014 10:51:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@unimore.it>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604175131.GA25388@infradead.org>
References: <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
 <20140602185138.GD8912@htj.dyndns.org>
 <20140602205713.GB8357@kernel.dk>
 <20140604143136.GA1920@infradead.org>
 <20140604145053.GE5004@htj.dyndns.org>
 <20140604145330.GA2955@infradead.org>
 <20140604145829.GF5004@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604145829.GF5004@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:58:29AM -0400, Tejun Heo wrote:
> I think what Jens is planning is something really minimal.  Things
> like [cb]fq heavily depend on the old block infrastructure.  I don't
> know.  Maybe they can be merged in time but I'm not quite sure we'd
> have enough pressure to actually do that.  Host-granular switching
> should be good enough, I guess.

Jens told me he wanted to do a deadline scheduler, which actually is
the most sensible for disks unless you want all the cgroup magic.

Given that people in this thread are interested in more complex
schedulers I'd suggest they implement BFQ for blk-mq.

