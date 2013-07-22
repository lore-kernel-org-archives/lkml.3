Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3GVIiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:38:09 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49455 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3GVIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:38:06 -0400
Date: Mon, 22 Jul 2013 09:37:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 2/4] MFD: ti_tscadc: disable TSC config registers in adc
 mode
Message-ID: <20130722083758.GG4681@laptop>
References: <1374337656-6393-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374337656-6393-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374337656-6393-3-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jul 2013, Zubair Lutfullah wrote:

> From: "Patil, Rachna" <rachna@ti.com>
> 
> AFE Pen Ctrl and TouchScreen transistors enabling is not
> required when only ADC mode is being used, so check for availability of
> TSC driver before accessing control register.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/mfd/ti_am335x_tscadc.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
