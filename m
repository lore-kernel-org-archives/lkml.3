Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaHUNDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:03:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaHUNDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:03:31 -0400
Date: Thu, 21 Aug 2014 06:03:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-fsdevel@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: Performance degradation in IO writes vs. reads (was scsi-mq V2)
Message-ID: <20140821130315.GB1567@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org>
 <53C39F36.9010003@dev.mellanox.co.il>
 <53F5E6C9.1020207@dev.mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F5E6C9.1020207@dev.mellanox.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 03:32:09PM +0300, Sagi Grimberg wrote:
> So I just got back to checking this issue of *extremely low* IO write
> performance I got in 3.16-rc2.

Please test with 3.16 final.  There once issue each in aio and dio
that caused bad I/O performance regression that were only fixed last
minute in the 3.16 cycle.

