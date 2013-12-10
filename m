Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3LJUyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:54:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3LJUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:54:00 -0500
Date: Tue, 10 Dec 2013 12:55:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] PHY: Fixes for 3.13-rc
Message-ID: <20131210205539.GA10402@kroah.com>
References: <1386332480-31671-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386332480-31671-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:51:17PM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> We have three patches to be merged in PHY subsystem for this rc cycle and
> all of them are critical.
> 
> One fixes a memory leak, the other solves a NULL dereference while calling
> dev_WARN and the last one fixes a randconfig error.
> 
> Let me know if I have to change anything.
> 
> I've also queued these fixes in
> https://git.kernel.org/cgit/linux/kernel/git/kishon/linux-phy.git/ fixes
> (contains patches to be merged in other trees too).

Ick, I can't take that, as it wouldn't work properly.  If you want to
send me pull requests, please use the proper format and a signed tag.

> Dan Carpenter (1):
>   drivers: phy: tweaks to phy_create()
> 
> Kishon Vijay Abraham I (1):
>   phy: kconfig: add depends on "USB_PHY" to OMAP_USB2 and TWL4030_USB
> 
> Sachin Kamat (1):
>   drivers: phy: Fix memory leak

I've now taken these, sorry for the delay.

greg k-h
