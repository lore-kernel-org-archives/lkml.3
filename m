Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaBNXRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:17:12 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40376 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaBNXRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:17:10 -0500
MIME-Version: 1.0
In-Reply-To: <1392248547-11627-1-git-send-email-markus.mayer@linaro.org>
References: <1392248547-11627-1-git-send-email-markus.mayer@linaro.org>
Date: Fri, 14 Feb 2014 15:17:09 -0800
Message-ID: <CAEPRUYoONkQ9HHiUj2mH3WE+Run4w-jmDpkZrgouQTUC4=zvWg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add Broadcom GPIO maintainer
From: Christian Daudt <bcm@fixthebug.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 3:42 PM, Markus Mayer <markus.mayer@linaro.org> wrote:
> List myself as maintainer for Broadcom's Kona GPIO driver.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>
> Does that look like a reasonable way to make this change? I added the
> entry alphabetically in the BROADCOM section.
>
>  MAINTAINERS |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2cf5cf..896cf2b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1909,6 +1909,13 @@ L:       linux-scsi@vger.kernel.org
>  S:     Supported
>  F:     drivers/scsi/bnx2i/
>
> +BROADCOM KONA GPIO DRIVER
> +M:     Markus Mayer <markus.mayer@linaro.org>
> +L:     bcm-kernel-feedback-list@broadcom.com
> +S:     Supported
> +F:     drivers/gpio/gpio-bcm-kona.c
> +F:     Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
> +
>  BROADCOM SPECIFIC AMBA DRIVER (BCMA)
>  M:     Rafał Miłecki <zajec5@gmail.com>
>  L:     linux-wireless@vger.kernel.org
> --
> 1.7.9.5
>
Acked-by: Christian Daudt <bcm@fixthebug.org>
