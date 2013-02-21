Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3BUV6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:58:07 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60066 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3BUV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:58:05 -0500
Date: Thu, 21 Feb 2013 13:58:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130221215839.GB28131@kroah.com>
References: <20130221184010.GA24692@kroah.com>
 <CA+55aFwjbGRvGHhQQ7vUYP+wChp_ZBQ54ZFxzrRjTkdffcteWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwjbGRvGHhQQ7vUYP+wChp_ZBQ54ZFxzrRjTkdffcteWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 12:25:24PM -0800, Linus Torvalds wrote:
> On Thu, Feb 21, 2013 at 10:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > USB patches for 3.9-rc1
> >
> > Here's the big USB merge for 3.9-rc1
> >
> > Nothing major, lots of gadget fixes, and of course, xhci stuff.
> 
> Ok, so there were a couple of conflicts with Thierry Reding's series
> to convert devm_request_and_ioremap() users into
> devm_ioremap_resource(), where some of the old users had been
> converted to use other helper functions (eg omap_get_control_dev()).

That's fine.

> I left the omap_get_control_dev() users alone, but I do want to note
> that omap_control_usb_probe() itself now uses that
> devm_request_and_ioremap() function. And I did *not* extend the merge
> to do that kind of conversion in the helper function, so I'm assuming
> Thierry might want to extend his work. Assuming people care enough..

Yes, his plan was to do another sweep of the calls and hopefully remove
the old api in 3.10 or so once that is all cleaned up.

thanks,

greg k-h
