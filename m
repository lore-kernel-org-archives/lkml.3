Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab3JQVL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:11:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48966 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932333Ab3JQVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:11:56 -0400
Date: Thu, 17 Oct 2013 17:11:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: H Hartley Sweeten <hartleys@visionengravers.com>, Greg KH <greg@kroah.com>
cc: USB list <linux-usb@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>, <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2 v4] usb: ohci: remove ep93xx bus glue platform driver
In-Reply-To: <201310171329.12434.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.44L0.1310171710240.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, H Hartley Sweeten wrote:

> Convert ep93xx to use the OHCI platform driver and remove the
> ohci-ep93xx bus glue driver.
> 
> Enable CONFIG_OHCI_HCD_PLATFORM in the ep93xx_defconfig so that USB
> is still enabled by default on the EP93xx platform.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>

Good work; thanks a lot for doing this.

Greg, please merge both of these v4 patches.

Alan Stern

