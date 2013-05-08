Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3EHPL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:11:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47962
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab3EHPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:11:56 -0400
Date: Wed, 8 May 2013 17:11:26 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Block IO core changes for 3.10
Message-ID: <20130508151126.GP7800@kernel.dk>
References: <20130508145023.GN7800@kernel.dk>
 <CA+55aFy1z6bcEt5pOd3O58Mx9dk00uDxROcDCS+QUybLbMMh4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy1z6bcEt5pOd3O58Mx9dk00uDxROcDCS+QUybLbMMh4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08 2013, Linus Torvalds wrote:
> On Wed, May 8, 2013 at 7:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > Below are the block layer core changes for 3.10. The pull request
> > contains:
> 
> This is late in the game. I'm assuming this does *not* contain the
> stuff that you talked on on G+ that you were still working on at the
> beginning of the merge window?

No of course not, that stuff is still in development. It's in the
new-queue branch, with some luck it can make 3.11 perhaps. Or if not,
then 3.12. So it's a bit off still.

Frankly the pull is just late since I have been busy with that and
company bits. If you look at the history, there's been no changes in
more than a week.

> Quite frankly, I'm not at all interested in pulling stuff that wasn't
> ready when the merge window opened, and I'm not at all happy with
> getting this pull request in what is essentially the end of the merge
> window.

There are no new developments in that branch that haven't been done for
at least a merge window.

-- 
Jens Axboe

