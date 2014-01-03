Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaACUYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:24:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaACUYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:24:35 -0500
Date: Fri, 3 Jan 2014 12:24:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] usb patches for v3.14 merge window
Message-ID: <20140103202403.GA16018@kroah.com>
References: <1388097419-24041-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388097419-24041-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 04:36:59PM -0600, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's my overly extensive pull request for v3.14 merge window. Lots
> of work has happened for next merge window.
> 
> All patches have been tested with all ARM defconfigs, i386_defconfig,
> kvm_guest.config, x86_64_defconfig, plus quite a few randconfigs.
> 
> All latest 0-DAY reports have been fixed already a few days back.
> 
> I have test-merged this on top of your usb-next and no conflicts showed
> up.
> 
> Please, consider merging.
> 
> Happy New Year
> 
> The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:
> 
>   Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.14

Pulled and pushed out, thanks.

greg k-h
