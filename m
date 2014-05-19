Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaESOdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:33:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaESOdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:33:39 -0400
Date: Mon, 19 May 2014 07:33:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: time to move fs/bio.c to block/ ?
Message-ID: <20140519143337.GB568@infradead.org>
References: <20140519141309.GB21570@infradead.org>
 <CAHz2CGUXwQ33VwSYQFkBXMUFR=nH_JDf0Chzaj5PUNDMj3Au3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHz2CGUXwQ33VwSYQFkBXMUFR=nH_JDf0Chzaj5PUNDMj3Au3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:28:16PM +0800, Jianyu Zhan wrote:
> Hi, Christoph, Jens,
> 
> BTW, just out of curiosity,  the VFS infrastructure code is just scatterd
> around the fs directory, which is quite suprised to a new comer that why
> there is "no" vfs stuff in fs directory.  Does it make sense to also collect
> them into a dedicated sub-dir, maybe vfs.  IMHO, this could make code
> skeleton more clear and could avoid such mis-sending patches in a long
> term maintainability view.

fs/*.[ch] shouldn't be much that isn't VFS in the broader sense
(including library functions). Besides the block files the only the only
things that might make sense to move out are binfmt*.c, signalfd.c
and timerfd.c (to kernel/ ?).

> 
> Thanks,
> Jianyu Zhan
---end quoted text---
