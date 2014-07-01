Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbaGAH6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:58:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38716 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaGAH6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:58:12 -0400
Date: Tue, 1 Jul 2014 00:58:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs.h: Remove unnecessary extern prototypes
Message-ID: <20140701075802.GA9606@infradead.org>
References: <cover.1403999769.git.joe@perches.com>
 <c81908e88f71ca2c21a8e3eaf3e5f72bd8d6c322.1403999769.git.joe@perches.com>
 <20140630161944.bd57016cba11f47185dbe6c5@linux-foundation.org>
 <1404171091.2717.24.camel@joe-AO725>
 <20140630163909.9859f3c55406746129a69e77@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630163909.9859f3c55406746129a69e77@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 04:39:09PM -0700, Andrew Morton wrote:
> > I can fix it and resubmit if you like.
> 
> OK.  How about we wait for -rc6 or thereabouts?  That should minimise
> the pain profile.

Or just drop it.  This is the perfect example for a patch having
absolutely no real benefit and introducing a lot of churn.

People need to learn that randomly fixing style in code they don't
maintain or change in a major way is abosolutely poinless.  Help with
reviewing newly added code so that it has good style instead.

