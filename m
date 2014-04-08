Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaDHLiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:38:00 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46713 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaDHLh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:37:58 -0400
Date: Tue, 8 Apr 2014 12:37:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Subject: Re: [PATCH v5 3/3] memstick: Add realtek USB memstick host driver
Message-ID: <20140408113751.GG8888@lee--X1>
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>
 <1395744293-24398-4-git-send-email-rogerable@realtek.com>
 <533A3080.2020008@realtek.com>
 <20140401150654.fe27636428a62fdf9e0d2dc1@linux-foundation.org>
 <20140402151654.GA24060@lee--X1>
 <5343ADFA.7010703@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5343ADFA.7010703@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>From: Roger Tseng <rogerable@realtek.com>
> >>>>
> >>>>Realtek USB memstick host driver provides memstick host support based on the
> >>>>Realtek USB card reader MFD driver.
> >>>>
> >>>>Signed-off-by: Roger Tseng <rogerable@realtek.com>
> >>>>---
> >>>>   drivers/memstick/host/Kconfig       |  10 +
> >>>>   drivers/memstick/host/Makefile      |   1 +
> >>>>   drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
> >>>>   3 files changed, 850 insertions(+)
> >>>>   create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
> >>>Hi Andrew,
> >>>
> >>>Since I'll have to send next revision(v6, to modify patch 1/3) and
> >>>you've commented v4, would you also comment or Ack the 3/3 of this one?
> >>>This should save one revision for me to make any necessary change.
> >>
> >>It looks OK to my inexpert eye.  It would be better if Maxim and/or Alex
> >>could review the code.  If that doesn't happen then I guess the best we
> >>can do is to go ahead and merge it.  Have you worked out via which tree
> >>the patches will be merged?
> >
> >I'll be happy to take the set if one of the subsystem experts would be
> >kind enough to cast an eye over it.
> >
> >Maxim, Alex?
> >
> Lee,
> 
> When I prepare my next submission, I found a previous version of
> this patch set(and only the 1/3 'mfd' part)  seems to be merged in
> the following commit:
> 
> commit e5744abb2fa3629aa5a94e21ca1eae32ff2fe00b
> Merge: c29aa15 2d28ca7
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Apr 7 10:24:18 2014 -0700
> 
>     Merge tag 'mfd-for-linus-3.15' of
> git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
> 
> Is there any chance to revert it? Or what can I do to help current
> situation?

What will happen if we don't revert it? Does it depend on something
else?

> note: the merged commit:
> commit 730876be256603b4ee7225a125467d97a7ce9060
> Author: Roger Tseng <rogerable@realtek.com>
> Date:   Wed Feb 12 18:00:36 2014 +0800
> 
>     mfd: Add realtek USB card reader driver
> 
> 
> Best regards,
> Roger Tseng

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
