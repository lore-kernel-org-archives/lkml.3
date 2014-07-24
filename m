Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbaGXPa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:30:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759323AbaGXPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:30:58 -0400
Date: Thu, 24 Jul 2014 08:30:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: VFS tree for 3.17?
Message-ID: <20140724153057.GA1584@infradead.org>
References: <20140716114136.GA25237@infradead.org>
 <20140722162455.GA15053@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722162455.GA15053@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've pushed out the current queue to:

git://git.infradead.org/users/hch/vfs.git vfs-for-3.17

Stephen, can you include this in linux-next for testing?  I plan to
send the first two patches to Linus on Saturday as they seems worth
to fix for this release still, between a user triggered refcount one off
and a fix for a just introduced warning.

If there's anything else for 3.17 please send it my way.

