Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaDYKfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:35:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaDYKfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:35:41 -0400
Date: Fri, 25 Apr 2014 03:35:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull file locking changes for v3.15 (pile #2)
Message-ID: <20140425103537.GA10757@infradead.org>
References: <20140424074557.57f91e16@tlielax.poochiereds.net>
 <20140425095739.GB22295@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425095739.GB22295@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 05:57:39AM -0400, J. Bruce Fields wrote:
> > Jeff Layton (3):
> >       locks: allow __break_lease to sleep even when break_time is 0
> >       locks: rename file-private locks to "open file description locks"
> 
> Nit: they're "descriptors", not "descriptions".

No, in this case they are not.

