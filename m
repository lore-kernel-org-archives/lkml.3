Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3CBOwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 09:52:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59053 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3CBOwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 09:52:24 -0500
Message-ID: <51321242.9070707@ti.com>
Date: Sat, 2 Mar 2013 15:52:50 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130301 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: twl4030-audio: Fix argument type for twl4030_audio_disable_resource()
References: <1362209435-11029-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1362209435-11029-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2013 08:30 AM, Mark Brown wrote:
> Looks like the conversion to enum was missed for the definition of this
> function, the declaration has been updated.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/twl4030-audio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
> index e16edca..d2ab222 100644
> --- a/drivers/mfd/twl4030-audio.c
> +++ b/drivers/mfd/twl4030-audio.c
> @@ -118,7 +118,7 @@ EXPORT_SYMBOL_GPL(twl4030_audio_enable_resource);
>   * Disable the resource.
>   * The function returns with error or the content of the register
>   */
> -int twl4030_audio_disable_resource(unsigned id)
> +int twl4030_audio_disable_resource(enum twl4030_audio_res id)
>  {
>  	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
>  	int val;
> 


-- 
Péter
