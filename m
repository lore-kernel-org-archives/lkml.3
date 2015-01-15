Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbbAOA2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:28:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbAOA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:28:15 -0500
Date: Wed, 14 Jan 2015 16:28:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches
Message-ID: <20150115002815.GA7942@kroah.com>
References: <1421257719-13711-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421257719-13711-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:48:39AM -0600, Felipe Balbi wrote:
> Hi Greg,
> 
> Alright, 3 more fixes for v3.19-rc and my queue is finally clean.
> 
> All three fixes are rather obvious, two of them just took longer
> to sort out all the stable rules details and I ended up having
> to fix all that, otherwise we would miss the time frame.
> 
> Please condiser merging to your greg/usb-linus branch.
> 
> cheers
> 
> The following changes since commit 5fb694f96e7c19e66b1c55124b98812e32e3efa5:
> 
>   usb: gadget: udc: atmel: fix possible oops when unloading module (2015-01-09 18:15:11 -0600)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.19-rc6

Pulled and pushed out, thanks.

greg k-h
