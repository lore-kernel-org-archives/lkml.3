Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3EHQjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:39:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48469
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276Ab3EHQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:39:15 -0400
Date: Wed, 8 May 2013 18:38:43 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Block IO core changes for 3.10
Message-ID: <20130508163843.GQ7800@kernel.dk>
References: <20130508145023.GN7800@kernel.dk>
 <CA+55aFy1z6bcEt5pOd3O58Mx9dk00uDxROcDCS+QUybLbMMh4Q@mail.gmail.com>
 <20130508151126.GP7800@kernel.dk>
 <CA+55aFweu3tVnt-1=G8cx_Xi+_3X7DFvPv0qHbdBptD3Tm6ztg@mail.gmail.com>
 <CA+55aFwKUVW4xe5eVToORXYkJ0bkACdcwfE=g8oaZeYPxAjUoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwKUVW4xe5eVToORXYkJ0bkACdcwfE=g8oaZeYPxAjUoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08 2013, Linus Torvalds wrote:
> On Wed, May 8, 2013 at 9:03 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, May 8, 2013 at 8:11 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Frankly the pull is just late since I have been busy with that and
> >> company bits. If you look at the history, there's been no changes in
> >> more than a week.
> >
> > Ok, good. The timing made me nervous..
> 
> Oh, and should I made BIO_RESET_BITS and BIO_OWNS_VEC be 13? We have a

The numbers aren't important, as long as they are different.

> new BIO_SNAP_STABLE that is 12, and I'm really hoping these values
> aren't exposed anywhere to users..

Strictly in-kernel stuff, so no problems there. No bio flags are
propagated to user space.

-- 
Jens Axboe

