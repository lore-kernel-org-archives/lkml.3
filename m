Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaDBPRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:17:13 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47023 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaDBPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:17:12 -0400
Date: Wed, 2 Apr 2014 16:16:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roger <rogerable@realtek.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Subject: Re: [PATCH v5 3/3] memstick: Add realtek USB memstick host driver
Message-ID: <20140402151654.GA24060@lee--X1>
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>
 <1395744293-24398-4-git-send-email-rogerable@realtek.com>
 <533A3080.2020008@realtek.com>
 <20140401150654.fe27636428a62fdf9e0d2dc1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140401150654.fe27636428a62fdf9e0d2dc1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014, Andrew Morton wrote:

> On Tue, 1 Apr 2014 11:20:32 +0800 Roger <rogerable@realtek.com> wrote:
> 
> > On 03/25/2014 06:44 PM, rogerable@realtek.com wrote:
> > > From: Roger Tseng <rogerable@realtek.com>
> > >
> > > Realtek USB memstick host driver provides memstick host support based on the
> > > Realtek USB card reader MFD driver.
> > >
> > > Signed-off-by: Roger Tseng <rogerable@realtek.com>
> > > ---
> > >   drivers/memstick/host/Kconfig       |  10 +
> > >   drivers/memstick/host/Makefile      |   1 +
> > >   drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
> > >   3 files changed, 850 insertions(+)
> > >   create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
> > Hi Andrew,
> > 
> > Since I'll have to send next revision(v6, to modify patch 1/3) and 
> > you've commented v4, would you also comment or Ack the 3/3 of this one? 
> > This should save one revision for me to make any necessary change.
> 
> It looks OK to my inexpert eye.  It would be better if Maxim and/or Alex
> could review the code.  If that doesn't happen then I guess the best we
> can do is to go ahead and merge it.  Have you worked out via which tree
> the patches will be merged?

I'll be happy to take the set if one of the subsystem experts would be
kind enough to cast an eye over it.

Maxim, Alex?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
