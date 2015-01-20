Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbbATL67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:58:59 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45266 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbATL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:58:57 -0500
Date: Tue, 20 Jan 2015 11:58:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] mfd: smsc-ece1099: Constify struct regmap_config
Message-ID: <20150120115851.GV13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-10-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-10-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/smsc-ece1099.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/smsc-ece1099.c b/drivers/mfd/smsc-ece1099.c
> index 90112d4cc905..03246880d484 100644
> --- a/drivers/mfd/smsc-ece1099.c
> +++ b/drivers/mfd/smsc-ece1099.c
> @@ -24,7 +24,7 @@
>  #include <linux/mfd/smsc.h>
>  #include <linux/of_platform.h>
>  
> -static struct regmap_config smsc_regmap_config = {
> +static const struct regmap_config smsc_regmap_config = {
>  		.reg_bits = 8,
>  		.val_bits = 8,
>  		.max_register = SMSC_VEN_ID_H,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
