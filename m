Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3IWIZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:25:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44194 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3IWIZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:25:43 -0400
Date: Mon, 23 Sep 2013 09:25:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Correct register definition for
 FLL2_SYNC_BW
Message-ID: <20130923082538.GE2185@lee--X1>
References: <1379757724-28100-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379757724-28100-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Sep 2013, Charles Keepax wrote:

> We had specified the mask twice for FLL2_SYNC_BW change the first mask
> definition in a bit definition to match the other fields.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  include/linux/mfd/arizona/registers.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index 4706d3d..cb49417 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -1908,7 +1908,7 @@
>  #define ARIZONA_FLL2_SYNC_GAIN_MASK              0x003c  /* FLL2_SYNC_GAIN */
>  #define ARIZONA_FLL2_SYNC_GAIN_SHIFT                  2  /* FLL2_SYNC_GAIN */
>  #define ARIZONA_FLL2_SYNC_GAIN_WIDTH                  4  /* FLL2_SYNC_GAIN */
> -#define ARIZONA_FLL2_SYNC_BW_MASK                0x0001  /* FLL2_SYNC_BW */
> +#define ARIZONA_FLL2_SYNC_BW                     0x0001  /* FLL2_SYNC_BW */
>  #define ARIZONA_FLL2_SYNC_BW_MASK                0x0001  /* FLL2_SYNC_BW */
>  #define ARIZONA_FLL2_SYNC_BW_SHIFT                    0  /* FLL2_SYNC_BW */
>  #define ARIZONA_FLL2_SYNC_BW_WIDTH                    1  /* FLL2_SYNC_BW */

I don't really understand the point of the define, as they are always
the same as their associated *_MASK, but this patch is in keeping with
the remaining defines.

Applied, thanks.
 
-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
