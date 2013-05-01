Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab3EAQXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:23:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50262 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab3EAQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:23:18 -0400
X-Sasl-enc: 8Ou5HTjHUcp6Ndhrerv8jNVTPIveH/y8iT2B2rhIsZnE 1367425362
Date: Wed, 1 May 2013 09:22:41 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: remove remaining instances of USB_SUSPEND
Message-ID: <20130501162241.GB19120@kroah.com>
References: <Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1305011209370.929-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1305011209370.929-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 12:13:54PM -0400, Alan Stern wrote:
> Commit 84ebc10294a3d7be4c66f51070b7aedbaa24de9b (USB: remove
> CONFIG_USB_SUSPEND option) failed to remove all of the usages of
> USB_SUSPEND throughout the kernel.  This patch (as1677) removes the
> remaining instances of that symbol.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> As promised, here is a patch to finish the removal of USB_SUSPEND.  
> It's up-to-date with 3.9 and Greg's usb-next tree as of Monday.  It's
> possible that changes made since then or coming through other
> subsystems have introduced new usages I'm not aware of.
> 
> It's up to the two of you to decide whether Linus should take this 
> directly or whether it should go through Greg.

I can take it after 3.10-rc1 is out, that way I'll also sweep the tree
for any remaining instances that other trees might have drug in during
the merge window process.

thanks,

greg k-h
