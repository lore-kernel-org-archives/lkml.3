Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3GVIhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:37:07 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40374 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab3GVIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:37:03 -0400
Date: Mon, 22 Jul 2013 09:36:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 3/4] MFD: ti_tscadc: ADC Clock check not required
Message-ID: <20130722083651.GF4681@laptop>
References: <1374337656-6393-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374337656-6393-4-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374337656-6393-4-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jul 2013, Zubair Lutfullah wrote:

> From: "Patil, Rachna" <rachna@ti.com>
> 
> ADC is ideally expected to work at a frequency of 3MHz.
> The present code had a check, which returned error if the frequency
> went below the threshold  value. But since AM335x supports various
> working frequencies, this check is not required.
> Now the code just uses the internal ADC clock divider to set the ADC
> frequency w.r.t the sys clock.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/mfd/ti_am335x_tscadc.c       |    6 +-----
>  include/linux/mfd/ti_am335x_tscadc.h |    1 -
>  2 files changed, 1 insertion(+), 6 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
