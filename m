Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaAFJgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:36:09 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50963 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaAFJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:36:07 -0500
Date: Mon, 6 Jan 2014 09:36:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] iio: ti_am335x_adc: Adjust the closing bracket in
 tiadc_read_raw()
Message-ID: <20140106093602.GF23772@lee--X1>
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
 <1387466911-3732-2-git-send-email-bigeasy@linutronix.de>
 <52B71973.1000907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52B71973.1000907@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Dec 2013, Jonathan Cameron wrote:

> On 12/19/13 15:28, Sebastian Andrzej Siewior wrote:
> > It somehow looks like the ending bracket belongs to the if statement but
> > it does belong to the while loop. This patch moves the bracket where it
> > belongs.
> > 
> > Reviewed-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Acked-by: Jonathan Cameron <jic23@kernel.org>
> 
> Lee, I'm assuming you are fine taking the whole series!

Sure, no problem.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
