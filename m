Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaJ0NjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:39:24 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:58612 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaJ0NjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <1413883364-681-5-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1413883364-681-5-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 27 Oct 2014 14:39:20 +0100
Message-ID: <CAPDyKFokMoL7ueeQf_vMAhJJ9SZJPBy0AZFWrGtDFyv5iR1wrg@mail.gmail.com>
Subject: Re: [PATCH RESEND 04/12] mmc: sdhci-pxav3: Remove unused clk_enable
 from sdhci_pxa
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 11:22, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> clk_enable from struct sdhci_pxa is unused, remove it from the private
> driver data.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks! Applied for next!

Kind regards
Uffe


> ---
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/sdhci-pxav3.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 48bc8179c8fc..d1f63d32b2cd 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -59,7 +59,6 @@
>  #define SDCE_MISC_INT_EN       (1<<1)
>
>  struct sdhci_pxa {
> -       u8      clk_enable;
>         u8      power_mode;
>  };
>
> --
> 2.1.1
>
