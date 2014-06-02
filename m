Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaFBJnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:43:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaFBJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:43:05 -0400
Date: Mon, 2 Jun 2014 02:42:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] basic conversion to blk-mq
Message-ID: <20140602094251.GA30612@infradead.org>
References: <1401400285-25003-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401400285-25003-1-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:51:24PM +0200, Matias Bj??rling wrote:
> Hi Matthew and Keith,
> 
> Thanks for the quick review.
> 
> The patch has been updated with the feedback from Keith and Jens. It's against
> Jens' 3.16/core tree. You may use the nvmemq_wip_review branch at:
> 
> https://github.com/MatiasBjorling/linux-collab nvmemq_wip_review

It seems like this includes more patches than the one you're sending
out, care to send the full series next time?

