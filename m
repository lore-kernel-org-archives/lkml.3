Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaKKHJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:09:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaKKHJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:09:18 -0500
Date: Tue, 11 Nov 2014 16:07:59 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lauri Niskanen <ape@ape3000.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: misc: Add driver for ALVA Nanoface
Message-ID: <20141111070759.GA16276@kroah.com>
References: <1415689506-1755-1-git-send-email-ape@ape3000.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415689506-1755-1-git-send-email-ape@ape3000.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:05:06AM +0200, Lauri Niskanen wrote:
> ALVA Nanoface is a USB audio interface device that only works after
> receiving an initialization command. This driver does not handle any
> actual audio features, but only initializes the device enabling its
> audio I/O and physical controls. There are some additional USB audio
> features on the device that are currently not supported. The support
> for these features may be added later.
> 
> Signed-off-by: Lauri Niskanen <ape@ape3000.com>
> ---
>  drivers/usb/misc/Kconfig    |  9 +++++
>  drivers/usb/misc/Makefile   |  1 +
>  drivers/usb/misc/nanoface.c | 95 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 105 insertions(+)
>  create mode 100644 drivers/usb/misc/nanoface.c

Any reason this can't be a simple userspace program that writes the
needed command to the device using libusb instead of being a kernel
driver?  This seems like overkill for a kernel driver to me.

thanks,

greg k-h
