Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaAFJ2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:28:13 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56122 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaAFJ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:28:11 -0500
Date: Mon, 6 Jan 2014 09:28:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: max14577: Remove redundant of_match_ptr helper
Message-ID: <20140106092806.GB23772@lee--X1>
References: <1387621216-9745-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387621216-9745-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013, Sachin Kamat wrote:

> 'max14577_dt_match' is always compiled in. Hence the
> helper macro is not needed.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/max14577.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index a5e1c370c609..ac514fb2b877 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -221,7 +221,7 @@ static struct i2c_driver max14577_i2c_driver = {
>  		.name = "max14577",
>  		.owner = THIS_MODULE,
>  		.pm = &max14577_pm,
> -		.of_match_table = of_match_ptr(max14577_dt_match),
> +		.of_match_table = max14577_dt_match,
>  	},
>  	.probe = max14577_i2c_probe,
>  	.remove = max14577_i2c_remove,

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
