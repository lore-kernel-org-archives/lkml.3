Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbbAESlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:41:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbAESlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:41:52 -0500
Date: Mon, 5 Jan 2015 10:41:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v12 00/20] DAX: Page cache bypass for filesystems on
 memory storage
Message-ID: <20150105184143.GA665@infradead.org>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <20141210140347.GA23252@infradead.org>
 <20141210141211.GD2220@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210141211.GD2220@wil.cx>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 09:12:11AM -0500, Matthew Wilcox wrote:
> On Wed, Dec 10, 2014 at 06:03:47AM -0800, Christoph Hellwig wrote:
> > What is the status of this patch set?
> 
> I have no outstanding bug reports against it.  Linus told me that he
> wants to see it come through Andrew's tree.  I have an email two weeks
> ago from Andrew saying that it's on his list.  I would love to see it
> merged since it's almost a year old at this point.

And since then another month and aother merge window has passed.  Is
there any way to speed up merging big patch sets like this one?

Another one is non-blocking read one that has real life use on one
of the biggest server side webapp frameworks but doesn't seem to make
progress, which is a bit frustrating.
