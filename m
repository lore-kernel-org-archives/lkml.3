Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3AQS7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:59:47 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:41905 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3AQS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:44 -0500
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 13:59:44 EST
Date: Thu, 17 Jan 2013 10:59:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] init, block: try to load default elevator module
 early during boot
Message-ID: <20130117185935.GC16568@mtj.dyndns.org>
References: <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130117183830.GA16568@mtj.dyndns.org>
 <CA+55aFzeUPbvEMDTKis98TKkY68k4GtzPXCWEQVKKzWf7eVDoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzeUPbvEMDTKis98TKkY68k4GtzPXCWEQVKKzWf7eVDoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:46:47AM -0800, Linus Torvalds wrote:
> On Thu, Jan 17, 2013 at 10:38 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Oh yeah, it's coming.  I just wanted to finish something else first
> > and, as turning on PF_WQ_WORKER on a rescuer thread has some chance of
> > developing into an obscure difficult-to-trigger and diagnose problem,
> > don't want to hurry it too much.
> 
> Ok. I think I'll delay these things for 3.9 anyway, since the actual
> _problem_ people are seeing should be fixed with your other patch. So
> I guess it's not really all that critical any more.

If you're okay with it, I'll route these two and the patches to add
warning through a wq branch.  There's already a wq/for-3.9 patch which
am_i_async() can make use of, so it's gonna be easier this way.

Thanks.

-- 
tejun
