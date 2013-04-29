Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3D2SjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:39:01 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:36388 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab3D2Siy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:38:54 -0400
Date: Mon, 29 Apr 2013 11:38:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
Message-ID: <20130429183851.GA8106@kroah.com>
References: <20130429162115.GA6893@kroah.com>
 <CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:28:40AM -0700, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 9:21 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Here's the big char / misc driver update for 3.10-rc1
> 
> Ugh. What the f*ck is up with stuff like this:
> 
> >  drivers/ssbi/Kconfig                               |  16 +
> >  drivers/ssbi/Makefile                              |   1 +
> >  drivers/ssbi/ssbi.c                                | 379 ++++++++++++++
> 
> Seriously? "ssbi" is such a major driver subsystem that it needs its
> own subdirectory at the top level?
> 
> We can't just go adding random single drivers at the top level. Now,
> giving it a subdirectory of its own is certainly fine (there should be
> more drivers that decide "I'll put my files away from others", but it
> should be under drivers/misc/ or something. There's no way this is at
> the same level as "networking" or "pci".

It's a "bus" type, that has individual drivers connecting to it.  I'm
pretty sure that David (now on to:) has a bunch more drivers queued up
for this directory, right David?

Now if we want to have a drivers/buses/ where we put these things,
that's fine with me, but so far, we seem to put new bus types directly
in drivers/

thanks,

greg k-h
