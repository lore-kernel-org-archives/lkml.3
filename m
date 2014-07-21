Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbaGUSez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:34:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbaGUSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:34:54 -0400
Date: Mon, 21 Jul 2014 11:34:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB changes for v3.17
Message-ID: <20140721183450.GA9849@kroah.com>
References: <1405956929-10169-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405956929-10169-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:35:29AM -0500, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's my big set of patches containing 97 commits. While it looks big and
> all, most commits are just cleanups moving code around, using devm_*, etc.
> 
> I tested these patches on a couple TI platforms and couldn't find any regressions
> on my setup.
> 
> This tree has also been on linux-next for a while.
> 
> Please consider merging on top of your usb-next branch or let me know if you
> want anything to change.
> 
> cheers
> 
> The following changes since commit 4c834452aad01531db949414f94f817a86348d59:
> 
>   Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.17

I've now merged and pushed this out.  I did have some merge conflicts in
these files:
	drivers/usb/musb/musb_core.c
	drivers/usb/musb/musb_cppi41.c
	include/uapi/linux/usb/functionfs.h

and I _think_ I resolved them properly, but getting verification of this
would be great.

thanks,

greg k-h
