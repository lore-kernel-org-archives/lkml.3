Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3A1OhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:37:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:58546 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab3A1OhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:37:22 -0500
Date: Mon, 28 Jan 2013 06:39:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.7.5
Message-ID: <20130128143907.GA2940@kroah.com>
References: <20130128045658.GA3488@kroah.com>
 <pan.2013.01.28.11.42.16.556318@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2013.01.28.11.42.16.556318@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:42:16PM +0100, Holger Hoffstaette wrote:
> On Sun, 27 Jan 2013 20:56:58 -0800, Greg KH wrote:
> 
> > I'm announcing the release of the 3.7.5 kernel.
> 
> Apologies for being late but I'm afraid I just found at least one
> regression in this release.
> 
> I have an external HDD in an USB3 enclosure for the occasional backup. I
> turn it on, it gets registered as sdX, I mount it/use it/unmount it and
> turn it off, which worked fine with kernels including 3.7.4.
> With 3.7.5 the kernel seems no longer notified of the changed device power
> status; nothing in dmesg and the device stays in the list of SCSI devices
> as e.g. shown by lsscsi. This is repeatable. Turning the device back
> on/using it works fine, it's just that I cannot dynamically remove it any
> longer.
> 
> I cannot run a bisect at the moment, but reading the changelog points
> to a few USB and libata related changes. I hope this helps.

If you could run 'git bisect' to determine which patch causes this
problem, that would be wonderful.

Also, does 3.8-rc5 work for you properly or not on this hardware?

thanks,

greg k-h
