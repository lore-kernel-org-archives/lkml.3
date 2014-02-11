Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaBKQe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:34:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaBKQe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:34:26 -0500
Date: Tue, 11 Feb 2014 08:35:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jbarnes@virtuousgeek.org
Subject: Re: Baytrail/T (ASUS T100 etc) regression from 3.13 onwards
Message-ID: <20140211163541.GB12567@kroah.com>
References: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
 <20140114120103.436d190b@alan.etchedpixels.co.uk>
 <20140211142203.77561e0f@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211142203.77561e0f@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 02:22:03PM +0000, One Thousand Gnomes wrote:
> On Tue, 14 Jan 2014 12:01:03 +0000
> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> > On Sun, 12 Jan 2014 20:33:03 +0700
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > Another week, another RC. And things look fine.
> > 
> > It seems to hate Baytrail/T
> > 
> > My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> > right but otherwise running nicely and playing 3D games to 3.13-rc8
> 
> This has now been pinned down to (confirmed by multiple people)
> 
> commit 6c4a8962a4a078cacfc8eb5d4bd79f6343b8cd7a
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Tue Sep 10 14:54:42 2013 -0700
> 
>     drm/i915/vlv: re-enable hotplug detect based probing on VLV/BYT
> 
> 
> which given this is affecting some of the top 10 Amazon selling new
> laptops and has not been fixed for 3.14-rc should IMHO be reverted until
> such time as any needed debugging for the MIPI panels is done for this
> driver and the hotplug probing doesn't break the workarounds.
> 
> Likewise it wants pulling from any -stable backports.

I only see it in the 3.13 tree, so when this gets reverted in Linus's
tree, can someone mark it for stable so I know to pick it up for
3.13-stable as well?

thanks,

greg k-h
