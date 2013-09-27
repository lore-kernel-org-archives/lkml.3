Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3I0IXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:23:15 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:35771 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3I0IXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:23:11 -0400
Date: Fri, 27 Sep 2013 09:23:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: Restore clock divider on resume
Message-ID: <20130927082306.GC9048@lee--X1>
References: <20130923204329.GG27515@raspi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130923204329.GG27515@raspi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013, Matthias Kaehlcke wrote:

> The ADC clock divider needs to be restored on resume as the register content
> is lost when the ADC is powered down
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> 
> ---
>  drivers/mfd/ti_am335x_tscadc.c       |   10 ++++++----
>  include/linux/mfd/ti_am335x_tscadc.h |    1 +
>  2 files changed, 7 insertions(+), 4 deletions(-)

I would question why 'struct ti_tscadc_dev' has different names
throughout the driver, but that has nothing to do with this patch.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
