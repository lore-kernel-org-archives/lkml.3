Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaGVQY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:24:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaGVQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:24:55 -0400
Date: Tue, 22 Jul 2014 09:24:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: VFS tree for 3.17?
Message-ID: <20140722162455.GA15053@infradead.org>
References: <20140716114136.GA25237@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716114136.GA25237@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:41:36AM -0700, Christoph Hellwig wrote:
> Hi Al,
> 
> Do you plan to put a VFS tree together for 3.17?  To me the various
> renameat2 bits from Miklos are something I'd really prefer to not miss,
> but there might be other bits waiting for attention as well.

Another weeks has passed and I'd really like to make sure we don't
let the VFS leap.

I'll try to put together a tree over the next days so we can at least
get a minium amount of linux-next exposure.  Candidates are:

 - the direct-io.c warning fix from Boaz (really should 3.16 actually)
 - the unmount on symlink reference count fix
 - the rename/rename2 patches from Mikilos.  These are a bit older
   and could use a respin.

Anything else I've missed?

