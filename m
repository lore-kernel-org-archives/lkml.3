Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaCHBFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:05:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaCHBFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:05:39 -0500
Date: Fri, 7 Mar 2014 17:07:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches for v3.15
Message-ID: <20140308010726.GA17585@kroah.com>
References: <1394238645-26796-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394238645-26796-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:30:45PM -0600, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's my pull request for v3.15 merge window.
> 
> This pull request contains patches which have been soaking in linux-next for
> quite a bit of time. I also ran everything through my 150 randconfigs script
> (which uses some seeds of my own).
> 
> Please, consider merging it on top of your greg/usb-next branch.
> 
> Note that this pull request is based off of an old commit on your usb-next
> branch because I was out for a while on vacations and wanted to avoid
> duplicated commits.
> 
> cheers
> 
> 
> The following changes since commit 6d36b6f313738e99fc8b903697f8ecf06add29aa:
> 
>   phy-core: Don't allow building phy-core as a module (2014-02-15 12:28:39 -0800)

Pulled and pushed out, thanks.

greg k-h
