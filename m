Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682Ab3BNXFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:05:06 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52782 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548Ab3BNXFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:05:04 -0500
Date: Thu, 14 Feb 2013 15:05:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 7/9] ARM defconfigs: add missing inclusions of
 linux/platform_device.h
Message-ID: <20130214230501.GA30269@kroah.com>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
 <1360880818-4071454-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360880818-4071454-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:26:56PM +0100, Arnd Bergmann wrote:
> Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
> removed an implicit inclusion of linux/platform_device.h
> In a number of places. This adds back explicit inclusions in a few
> more places I found.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---
>  arch/arm/plat-samsung/include/plat/adc.h | 1 +
>  drivers/video/clps711xfb.c               | 1 +
>  drivers/video/mmp/fb/mmpfb.c             | 1 +

This file isn't my tty tree, so I can't apply that part of the patch,
but I've applied the rest of the patch, and the 2 others you sent me to
fix this issue.

thanks,

greg k-h
