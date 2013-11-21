Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3KUJ6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:58:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3KUJ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:58:46 -0500
Date: Thu, 21 Nov 2013 01:58:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
Message-ID: <20131121095837.GB18232@infradead.org>
References: <528A648F.1030007@oracle.com>
 <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 01:19:33PM -0800, Linus Torvalds wrote:
> I really don't see the point of all this crap. All this for the loop
> driver? If so, it had better at least be prettier than it is.

It's for anyone trying to to direct I/O from kernel space.  I have
patches that speed up ecryptfs and allow sane operation for the file
backed scsi target based on this that have been collecting dust for a
while.

