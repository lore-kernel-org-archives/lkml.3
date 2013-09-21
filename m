Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3IUXRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 19:17:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3IUXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 19:17:34 -0400
Date: Sat, 21 Sep 2013 16:18:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH][RFC] Fix breakage in ffs_fs_mount()
Message-ID: <20130921231816.GC2769@kroah.com>
References: <20130920161421.GR13318@ZenIV.linux.org.uk>
 <xa1tsiwzytqf.fsf@mina86.com>
 <20130921145126.GT13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130921145126.GT13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 03:51:26PM +0100, Al Viro wrote:
> On Sat, Sep 21, 2013 at 01:10:48AM +0200, Michal Nazarewicz wrote:
> > On Fri, Sep 20 2013, Al Viro wrote:
> > > 	There's a bunch of failure exits in ffs_fs_mount() with
> > > seriously broken recovery logics.  Most of that appears to stem
> > > from misunderstanding of the ->kill_sb() semantics;
> > 
> > That sounds likely.
> > 
> > [???]
> > 
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> Umm...  Which tree should that go through?  I can put it in vfs.git, of
> course, but it's local to drivers/usb/gadget, so a usb tree might be
> a better fit...  It's -stable fodder, all way back to linux-3.3.y.

I'll take it through the USB tree and mark it for stable trees as well,
thanks.

greg k-h
