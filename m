Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3LMQXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:23:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab3LMQXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:23:09 -0500
Date: Fri, 13 Dec 2013 11:22:28 -0500
From: Dave Jones <davej@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS / writeback invoking soft lockup.
Message-ID: <20131213162228.GA29908@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20131213071407.GA6527@redhat.com>
 <20131213104853.GS10988@dastard>
 <20131213111639.GD23546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213111639.GD23546@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:16:39AM -0800, Christoph Hellwig wrote:
 > On Fri, Dec 13, 2013 at 09:48:53PM +1100, Dave Chinner wrote:
 > > All I can say is that there doesn't look to be any obvious signs
 > > that this is a XFS or writeback problem fom the stack trace, and
 > > without more information or a reproducable test case I'm not going
 > > to be able to understand the cause.
 > > 
 > > Is the problem reproducable, or is it just a one-off?
 > 
 > If it's reproducable it would be good to enable the xfs_writepage
 > tracepoint and get a trace-cmd log of it.

I hit it pretty reliably last night.  I'll make a note to look into it 
on monday with that enabled.

	Dave

