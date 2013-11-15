Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3KOQ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:26:01 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53848 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3KOQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:25:55 -0500
Date: Fri, 15 Nov 2013 16:25:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5110: Correct default for register LDO2 Control 1
Message-ID: <20131115162549.GB3638@lee--X1>
References: <1384524199-7358-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384524199-7358-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, Charles Keepax wrote:

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index bf8b3b5..d3d7531 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -504,7 +504,7 @@ static const struct reg_default wm5110_reg_default[] = {
>  	{ 0x000001AA, 0x0004 },    /* R426   - FLL2 GPIO Clock */
>  	{ 0x00000200, 0x0006 },    /* R512   - Mic Charge Pump 1 */
>  	{ 0x00000210, 0x0184 },    /* R528   - LDO1 Control 1 */
> -	{ 0x00000213, 0x0344 },    /* R531   - LDO2 Control 1 */
> +	{ 0x00000213, 0x03E4 },    /* R531   - LDO2 Control 1 */
>  	{ 0x00000218, 0x01A6 },    /* R536   - Mic Bias Ctrl 1 */
>  	{ 0x00000219, 0x01A6 },    /* R537   - Mic Bias Ctrl 2 */
>  	{ 0x0000021A, 0x01A6 },    /* R538   - Mic Bias Ctrl 3 */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
