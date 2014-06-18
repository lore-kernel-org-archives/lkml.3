Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbaFRH5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:57:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34177 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366AbaFRH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:57:10 -0400
Date: Wed, 18 Jun 2014 08:57:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] mfd: cros_ec: Fix the comment on cros_ec_remove()
Message-ID: <20140618075704.GK21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402954800-28215-2-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This comment was incorrect, so update it.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>

How many people did it take to write this patch? ;)

Acked-by: Lee Jones <lee.jones@linaro.org>

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  include/linux/mfd/cros_ec.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 887ef4f..7e9fe6e 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -148,8 +148,7 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
>  /**
>   * cros_ec_remove - Remove a ChromeOS EC
>   *
> - * Call this to deregister a ChromeOS EC. After this you should call
> - * cros_ec_free().
> + * Call this to deregister a ChromeOS EC, then clean up any private data.
>   *
>   * @ec_dev: Device to register
>   * @return 0 if ok, -ve on error

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
