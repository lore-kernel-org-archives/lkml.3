Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaB1WOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:14:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaB1WOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:14:20 -0500
Date: Fri, 28 Feb 2014 14:15:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: ly80toro@cip.cs.fau.de, andy.grover@gmail.com, valentina.manea.m@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH 1/3] staging/usbip: add uapi header to export usbip
 kernel interfaces
Message-ID: <20140228221558.GA17000@kroah.com>
References: <cover.1393542201.git.shuah.kh@samsung.com>
 <10c9784313c5bafc6410b95cb3b569d5925eeaaa.1393542201.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c9784313c5bafc6410b95cb3b569d5925eeaaa.1393542201.git.shuah.kh@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:27:25PM -0700, Shuah Khan wrote:
> usbip userspace has duplicated enum definition to report usbip device
> status maintained by the kernel. Adding an usbip uapi header file will
> define the kernel - userspace interface for this device status.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  include/uapi/linux/Kbuild  |    1 +
>  include/uapi/linux/usbip.h |   26 ++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>  create mode 100644 include/uapi/linux/usbip.h

Staging code should be self-contained within drivers/staging/

Now I know that a bunch of people are now working on this codebase, and
hopefully it will finally get moved out of staging someday soon, but
until then, I can't add this file in this location, sorry.

Look at how the drivers/staging/android code handles the uapi files, you
should try doing that instead.

thanks,

greg k-h
