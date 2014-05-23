Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaEWSlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:41:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEWSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:41:40 -0400
Date: Fri, 23 May 2014 20:47:38 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roger <rogerable@realtek.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, Andrew Morton <akpm@linux-foundation.org>,
        Lee Jones <lee.jones@linaro.org>, Oliver Neukum <oneukum@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v7 4/4] memstick: Add realtek USB memstick host driver
Message-ID: <20140523114738.GA7471@kroah.com>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
 <1397199203-2235-5-git-send-email-rogerable@realtek.com>
 <20140428101010.GR6264@lee--X1>
 <5360ACA4.80503@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5360ACA4.80503@realtek.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 03:56:20PM +0800, Roger wrote:
> On 04/28/2014 06:10 PM, Lee Jones wrote:
> >> From: Roger Tseng <rogerable@realtek.com>
> >>
> >> Realtek USB memstick host driver provides memstick host support based on the
> >> Realtek USB card reader MFD driver.
> >>
> >> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> >> ---
> >>   drivers/memstick/host/Kconfig       |  10 +
> >>   drivers/memstick/host/Makefile      |   1 +
> >>   drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
> >>   3 files changed, 850 insertions(+)
> >>   create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
> >
> > Applied, thanks.
> >
> Greg,
> 
> Since all patches have been applied and the device is now supported by 
> the new driver, would you remove the former staging one at 
> drivers/staging/rts5139? Similar removal had been done for our PCIE 
> devices in:
> 
> commit cd2112220b6b0a35fa12ba988a0dd837515dfaf8
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Oct 26 09:03:21 2012 -0700
> 
>      Staging: remove rts_pstor driver
> 

Now removed, thanks.

greg k-h
