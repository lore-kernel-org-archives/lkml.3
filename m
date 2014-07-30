Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaG3RUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:20:42 -0400
Received: from fieldses.org ([174.143.236.118]:36771 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbaG3RUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:20:41 -0400
Date: Wed, 30 Jul 2014 13:20:09 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: VFS tree for 3.17?
Message-ID: <20140730172008.GH26316@fieldses.org>
References: <20140716114136.GA25237@infradead.org>
 <20140722162455.GA15053@infradead.org>
 <20140724153057.GA1584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724153057.GA1584@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:30:57AM -0700, Christoph Hellwig wrote:
> I've pushed out the current queue to:
> 
> git://git.infradead.org/users/hch/vfs.git vfs-for-3.17
> 
> Stephen, can you include this in linux-next for testing?  I plan to
> send the first two patches to Linus on Saturday as they seems worth
> to fix for this release still, between a user triggered refcount one off
> and a fix for a just introduced warning.
> 
> If there's anything else for 3.17 please send it my way.

There's these fixes to d_splice_alias and related code:

	git://linux-nfs.org/~bfields/linux-topics.git for-viro

(last posted in June).

The project isn't really finished but I think those patches are
justifiable on their own.

Happy to repost.

--b.
