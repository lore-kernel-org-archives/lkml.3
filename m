Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaJUKB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:01:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbaJUKBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:01:23 -0400
Date: Tue, 21 Oct 2014 12:01:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Linux API <linux-api@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141021100121.GA23161@amd>
References: <20141016124741.GA3832@kroah.com>
 <CAKgNAkiPg8G13XZXG6CiaBFZ1yqY2J7_OAppDOGweuNpRaojuA@mail.gmail.com>
 <20141016231457.GB13592@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016231457.GB13592@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-17 01:14:57, Greg Kroah-Hartman wrote:
> On Thu, Oct 16, 2014 at 04:18:02PM +0200, Michael Kerrisk (man-pages) wrote:
> > On Thu, Oct 16, 2014 at 2:47 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > The Android binder code has been "stable" for many years now.  No matter
> > > what comes in the future, we are going to have to support this API, so
> > > might as well move it to the "real" part of the kernel as there's no
> > > real work that needs to be done to the existing code.
> > 
> > Where does one find the canonical documentation of the user-space API?
> 
> There really is only one "canonical" thing, and that is in the libbinder
> code in the Android userspace repository.  And it's not really
> "documentation" so much as, "a C file that interacts with the ioctls in
> the binder kernel code" :(
> 
> Think of this as just a random character driver with some funny ioctls
> that will never get really documented as there is only one user of it.

This is not random character driver, it is communication mechanism. It
should _not_ be a character driver.

And it should really be documented.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
