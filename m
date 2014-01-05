Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaAEDxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 22:53:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaAEDxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 22:53:50 -0500
Date: Sat, 4 Jan 2014 19:54:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Herbert Rosmanith <lkml@wildsau.enemy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.11.10: rtl8192cu device name, kernel crash
Message-ID: <20140105035401.GA11255@kroah.com>
References: <alpine.LNX.2.00.1401050108340.14069@wildsau.enemy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401050108340.14069@wildsau.enemy.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 01:13:53AM +0100, Herbert Rosmanith wrote:
> 
> hello list,
> 
> this afternoon I bought a new usb/wlan adapter, which identifies 
> itself as:
> 
>     # lsusb
>     ...
>     Bus 001 Device 017: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 802.11n WLAN Adapter
> 
> the first thing I noticed is that the device name is renamed:
> 
>     [ 4444.688299] systemd-udevd[3090]: renamed network interface wlan1 to wlp0s29f7u4u4u2
> 
> Excellent! I always hated that userfriendly and easy to remember names like "wlan1".
> Finally I have a more sophisticated name, "wlp0s29f7u4u4u2" that strictly follows
> The Tao Of Terribly Silly Device Naming.

Your distro does that, take it up with them.  Usually there's an option
to keep the "old" naming scheme somewhere, it should be documented
somewhere.

> By the way, kernel version is 3.11.10.

Which is pretty old, does 3.12 work better?

> As the device is handled by the rtl8192cu module, which is not in the 
> staging directory, it is considered stable, isn't it?

It might help to cc: the wireless developers about wireless driver
issues to get a better response...

greg k-h
