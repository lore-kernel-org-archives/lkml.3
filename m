Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab3HHH0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:26:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3HHH0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:26:33 -0400
Date: Thu, 8 Aug 2013 00:26:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: PREEMPT_RT vs bcache
Message-ID: <20130808072623.GA3509@infradead.org>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:28:18PM +0200, Ben Hutchings wrote:
> As Kent said back in 2011 (commit 84759c6d18c5), bcache needs
> {down,up}_read_non_owner().  But these are not implemented by the -rt
> patchset when PREEMPT_RT_FULL is enabled.  Can they be added, or is
> there a fundamental conflict here?

How did they get back in at all?  I'm pretty sure I removed them for
good reason.

