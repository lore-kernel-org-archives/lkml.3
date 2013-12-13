Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3LMLQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:16:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3LMLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:16:40 -0500
Date: Fri, 13 Dec 2013 03:16:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131213111639.GD23546@infradead.org>
References: <20131213071407.GA6527@redhat.com>
 <20131213104853.GS10988@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213104853.GS10988@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 09:48:53PM +1100, Dave Chinner wrote:
> All I can say is that there doesn't look to be any obvious signs
> that this is a XFS or writeback problem fom the stack trace, and
> without more information or a reproducable test case I'm not going
> to be able to understand the cause.
> 
> Is the problem reproducable, or is it just a one-off?

If it's reproducable it would be good to enable the xfs_writepage
tracepoint and get a trace-cmd log of it.

