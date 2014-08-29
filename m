Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaH2Jdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:33:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61428 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaH2Jde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:33:34 -0400
Date: Fri, 29 Aug 2014 10:33:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/mfd/davinci_voicecodec.h: Fix typo in
 include guard
Message-ID: <20140829093329.GG24579@lee--X1>
References: <1408726143-3014-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408726143-3014-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Rasmus Villemoes wrote:
> The include guard doesn't work as intended due to the transposition
> typo DAVINCI -> DAVINIC.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  include/linux/mfd/davinci_voicecodec.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Corrected non-standard $SUBJECT line and applied.

> diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
> index 5166935..cb01496 100644
> --- a/include/linux/mfd/davinci_voicecodec.h
> +++ b/include/linux/mfd/davinci_voicecodec.h
> @@ -21,7 +21,7 @@
>   */
>  
>  #ifndef __LINUX_MFD_DAVINCI_VOICECODEC_H_
> -#define __LINUX_MFD_DAVINIC_VOICECODEC_H_
> +#define __LINUX_MFD_DAVINCI_VOICECODEC_H_
>  
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
