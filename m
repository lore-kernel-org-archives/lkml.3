Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3KUKFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:05:45 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42640 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KUKFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:05:43 -0500
Date: Thu, 21 Nov 2013 02:06:09 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
Message-ID: <20131121100609.GB17871@kmo-pixel>
References: <528A648F.1030007@oracle.com>
 <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
 <20131121095837.GB18232@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121095837.GB18232@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 01:58:37AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 20, 2013 at 01:19:33PM -0800, Linus Torvalds wrote:
> > I really don't see the point of all this crap. All this for the loop
> > driver? If so, it had better at least be prettier than it is.
> 
> It's for anyone trying to to direct I/O from kernel space.  I have
> patches that speed up ecryptfs and allow sane operation for the file
> backed scsi target based on this that have been collecting dust for a
> while.

Can you post those patches somewhere? If that's the end goal of this
patch series, we should be able to look at them too.
