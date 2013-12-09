Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479Ab3LIVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:12:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3LIVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:12:31 -0500
Date: Mon, 9 Dec 2013 13:14:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.13-rc4
Message-ID: <20131209211406.GA14439@kroah.com>
References: <1386617210-29054-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386617210-29054-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 01:26:50PM -0600, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's another set of really obvious fixes for this rc cycle. All patches have
> been pending for a while.
> 
> Please consider merging on top of your usb-linus branch.
> 
> cheers
> 
> The following changes since commit 2cf93bea3d7b2dbf1e0ebfa9d381aad1b637e2aa:
> 
>   usb: gadget: f_mass_storage: call try_to_freeze only when its safe (2013-11-25 11:34:09 -0600)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.13-rc4

Pulled and pushed out now, thanks.

greg k-h
