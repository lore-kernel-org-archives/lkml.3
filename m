Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaBJOkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:40:22 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:41986 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaBJOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:40:18 -0500
Date: Mon, 10 Feb 2014 14:40:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, torvalds@linux-foundation.org, jeffm@suse.com
Subject: Re: [PATCH 1/1] openfirmware: trivial: Standardise formatting of
 'struct of_device_id' definition
Message-ID: <20140210144013.GA26697@lee--X1>
References: <1390489239-29001-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390489239-29001-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's commonly accepted that when defining a struct the '{' is appended
> onto the first line. This helps when searching for the definition using
> syntax similar to 'struct of_device_id {'.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mod_devicetable.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 45e9214..090e014 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -220,8 +220,7 @@ struct serio_device_id {
>  /*
>   * Struct used for matching a device
>   */
> -struct of_device_id
> -{
> +struct of_device_id {
>  	char	name[32];
>  	char	type[32];
>  	char	compatible[128];

Is anyone interested in this patch?

Or should is it okay to just take it through my tree?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
