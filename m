Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaG1Gqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:46:46 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33927 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaG1Gqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:46:45 -0400
Date: Mon, 28 Jul 2014 07:46:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: arizona: Add MICVDD to mapped regulators for
 wm8997
Message-ID: <20140728064640.GA3973@lee--X1>
References: <1406301884-7145-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406301884-7145-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Charles Keepax wrote:

> The previous update adding MICVDD to the regulator mappings:
> 
> mfd: arizona: Add MICVDD to mapped regulators
> 
> Only added the mapping for wm5102 and wm5110 but wm8997 also has a
> MICVDD supply that needs to be mapped back to the main Arizona device.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index e9c3563..e0d415e 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -613,6 +613,7 @@ static const struct mfd_cell wm5110_devs[] = {
>  };
>  
>  static const char *wm8997_supplies[] = {
> +	"MICVDD",
>  	"DBVDD2",
>  	"CPVDD",
>  	"SPKVDD",

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
