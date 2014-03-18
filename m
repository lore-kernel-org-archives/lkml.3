Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaCRJCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:02:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37977 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaCRJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:02:42 -0400
Date: Tue, 18 Mar 2014 09:02:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: mc13xxx: Move definitions out of structures
Message-ID: <20140318090237.GG25478@lee--X1>
References: <1394867287-14074-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394867287-14074-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  include/linux/mfd/mc13xxx.h | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
> index a326c85..d63b1d3 100644
> --- a/include/linux/mfd/mc13xxx.h
> +++ b/include/linux/mfd/mc13xxx.h
> @@ -117,10 +117,6 @@ struct mc13xxx_led_platform_data {
>  
>  #define MAX_LED_CONTROL_REGS	6
>  
> -struct mc13xxx_leds_platform_data {
> -	struct mc13xxx_led_platform_data *led;
> -	int num_leds;
> -
>  /* MC13783 LED Control 0 */
>  #define MC13783_LED_C0_ENABLE		(1 << 0)
>  #define MC13783_LED_C0_TRIODE_MD	(1 << 7)
> @@ -169,10 +165,13 @@ struct mc13xxx_leds_platform_data {
>  /* MC34708 LED Control 0 */

I don't see the line above in the MFD tree?

Which commit/branch/repo is this patch based on?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
