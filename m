Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3HMRHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:07:43 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54216 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab3HMRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:07:41 -0400
Date: Tue, 13 Aug 2013 18:07:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 3/4] input: ti_tsc: Enable shared IRQ for TSC and add
 overrun, underflow checks
Message-ID: <20130813170734.GJ15278@lee--X1>
References: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376412499-21007-4-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376412499-21007-4-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Zubair Lutfullah wrote:

> Enable shared IRQ to allow ADC to share IRQ line from
> parent MFD core. Only FIFO0 IRQs are for TSC and handled
> on the TSC side.
> 
> Patch also adds overrun and underflow irq handlers.
> 
> Russ Dill (TI) worked on overrun and underflow handlers.
> Rachna Patil (TI) laid ground work for shared IRQ.
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/input/touchscreen/ti_am335x_tsc.c |   37 +++++++++++++++++++++++++----
>  include/linux/mfd/ti_am335x_tscadc.h      |    2 ++
>  2 files changed, 34 insertions(+), 5 deletions(-)

For the MFD part when the remainder of the entries have been placed in
order:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
