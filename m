Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaAFJa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:30:59 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:53604 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbaAFJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:30:58 -0500
Date: Mon, 6 Jan 2014 09:30:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/2] mfd: rtl8411: Staticize local symbol
Message-ID: <20140106093054.GD23772@lee--X1>
References: <1387605142-4743-1-git-send-email-sachin.kamat@linaro.org>
 <1387605142-4743-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387605142-4743-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013, Sachin Kamat wrote:

> 'rtl8411_init_common_params' is local to this file.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/rtl8411.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
> index ada38ad54e87..fdd34c883d86 100644
> --- a/drivers/mfd/rtl8411.c
> +++ b/drivers/mfd/rtl8411.c
> @@ -470,7 +470,7 @@ static const u32 rtl8411b_qfn48_ms_pull_ctl_disable_tbl[] = {
>  	0,
>  };
>  
> -void rtl8411_init_common_params(struct rtsx_pcr *pcr)
> +static void rtl8411_init_common_params(struct rtsx_pcr *pcr)
>  {
>  	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
>  	pcr->num_slots = 2;

This has already been fixed.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
