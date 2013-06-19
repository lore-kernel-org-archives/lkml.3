Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab3FSJ6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:58:20 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47940 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab3FSJ6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <1371549940-18834-1-git-send-email-sachin.kamat@linaro.org>
References: <1371549940-18834-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 19 Jun 2013 15:28:18 +0530
Message-ID: <CAK9yfHydnzrAjtUcM8=ft0GZ3y7ALrSBQkn_V-YzDUnWETUedg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: davinci_voicecodec: Fix build breakage
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 18 June 2013 15:35, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Include the missing header file to fix the following build error:
> drivers/mfd/davinci_voicecodec.c: In function ‘davinci_vc_probe’:
> drivers/mfd/davinci_voicecodec.c:86:3: error: implicit declaration of function
> ‘io_v2p’ [-Werror=implicit-function-declaration]
>    (dma_addr_t)(io_v2p(davinci_vc->base) + DAVINCI_VC_WFIFO);
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> This series is based on Samuel's mfd-next tree and is compile tested.
> ---
>  include/linux/mfd/davinci_voicecodec.h |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
> index 0ab6132..6b0e974 100644
> --- a/include/linux/mfd/davinci_voicecodec.h
> +++ b/include/linux/mfd/davinci_voicecodec.h
> @@ -28,6 +28,7 @@
>  #include <linux/mfd/core.h>
>
>  #include <mach/edma.h>
> +#include <mach/hardware.h>
>
>  /*
>   * Register values.
> --
> 1.7.9.5
>

Now that you have applied patch 2 of this series and sent the pull
request, I guess Samuel will take this one directly.

-- 
With warm regards,
Sachin
