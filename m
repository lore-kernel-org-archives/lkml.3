Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3ETVuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:50:32 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:44516 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab3ETVub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:50:31 -0400
X-Greylist: delayed 2023 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2013 17:50:31 EDT
Date: Mon, 20 May 2013 23:16:31 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        hjk@hansjkoch.de
Subject: Re: [PATCH v4 1/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20130520211631.GA18956@local>
References: <1368802420-26723-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368802420-26723-1-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 05:53:39PM +0300, Eli Billauer wrote:
> This is the documentation for the Xillybus driver. It's intended for kernel
> maintainers, since actual users will most likely rely on other documentation.
> 
> It has turned out somewhat tricky to put Xillybus in one of the existing
> categories of device drivers. I placed it under drivers/uio, mainly because it
> shares the spirit of a generic driver allowing userspace programs to talk
> directly with hardware. Unlike the classic UIO devices, Xillybus' char files
> shouldn't be memory mapped, but rather used in the regular manner as streams
> of data.

In that case it simply isn't a UIO device.

> 
> This driver was previously posted under drivers/misc/. The misc device
> framework turned out to be inadequate, as the driver may create more than 100
> device files in some cases.

And that is a problem? If yes, try something else like sysfs. From your
description, this is a drivers/misc device for me.

Thanks,
Hans

