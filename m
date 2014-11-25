Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaKYRfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:35:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKYRfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:35:23 -0500
Date: Tue, 25 Nov 2014 09:35:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches for v3.19 merge window
Message-ID: <20141125173521.GA28406@kroah.com>
References: <1416928650-20218-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416928650-20218-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:17:30AM -0600, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's a giant pull request for v3.19. Patches have been
> on linux-next for quite a while - most of them at least - and
> I tested what I could - read, what I had HW for - on both
> BeagleBoneBlack and AM437x SK. Some has also been tested with
> BeagleBoard X15, but that's still not supported in mainline
> (probably v3.19 as well).
> 
> Anyway, let me know if you want to change anything.
> 
> cheers
> 
> The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:
> 
>   Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-for-v3.19

I had a merge conflict in drivers/usb/chipidea/otg_fsm.c, so you might
want to verify I got that change correct.

thanks,

greg k-h
