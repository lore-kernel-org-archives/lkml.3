Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaG3Uzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:55:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaG3Uyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:54:36 -0400
Date: Wed, 30 Jul 2014 13:54:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: VFS tree for 3.17?
Message-ID: <20140730205434.GA3505@infradead.org>
References: <20140716114136.GA25237@infradead.org>
 <20140722162455.GA15053@infradead.org>
 <20140724153057.GA1584@infradead.org>
 <20140730172008.GH26316@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730172008.GH26316@fieldses.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 01:20:09PM -0400, J. Bruce Fields wrote:
> There's these fixes to d_splice_alias and related code:
> 
> 	git://linux-nfs.org/~bfields/linux-topics.git for-viro
> 
> (last posted in June).
> 
> The project isn't really finished but I think those patches are
> justifiable on their own.

I've pulled in all the actual code changes.  I've skipped the export
change as I'm not going to pull in anything to make life easier for
leacher and cheaters.

