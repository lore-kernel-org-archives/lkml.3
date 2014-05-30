Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaE3J3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:29:55 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35732 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaE3J3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:29:53 -0400
Date: Fri, 30 May 2014 10:29:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@linaro.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Correct default for LDO Control 2 register
Message-ID: <20140530092947.GH2619@lee--X1>
References: <20140529161115.GA8799@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140529161115.GA8799@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Update the default value to match the patch.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index 9b9923c..02c44fd 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -333,7 +333,7 @@ static const struct reg_default wm5102_reg_default[] = {
>  	{ 0x000001AA, 0x0004 },   /* R426   - FLL2 GPIO Clock */ 
>  	{ 0x00000200, 0x0006 },   /* R512   - Mic Charge Pump 1 */ 
>  	{ 0x00000210, 0x00D4 },   /* R528   - LDO1 Control 1 */ 
> -	{ 0x00000212, 0x0001 },   /* R530   - LDO1 Control 2 */
> +	{ 0x00000212, 0x0000 },   /* R530   - LDO1 Control 2 */
>  	{ 0x00000213, 0x0344 },   /* R531   - LDO2 Control 1 */ 
>  	{ 0x00000218, 0x01A6 },   /* R536   - Mic Bias Ctrl 1 */ 
>  	{ 0x00000219, 0x01A6 },   /* R537   - Mic Bias Ctrl 2 */ 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
