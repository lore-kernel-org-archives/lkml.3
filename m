Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaFPM6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:58:05 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:35490 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPM6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <1402916796-1450-1-git-send-email-peter.griffin@linaro.org>
References: <1402916796-1450-1-git-send-email-peter.griffin@linaro.org>
Date: Mon, 16 Jun 2014 14:58:01 +0200
Message-ID: <CAPDyKFr01qP26kEr3-3BwXoPFjU_E842mrFvFL_MHKAotNSO8Q@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Fix DT documentation of eMMC high-speed DDR
 1.8/1.2V bindings.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2014 13:06, Peter Griffin <peter.griffin@linaro.org> wrote:
> Currently the documentation doesn't match the code in mmc_of_parse. This
> patch rectifies this.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Thanks! Applied to my mmc tree for next.

Kind regards
Uffe

> ---
>  Documentation/devicetree/bindings/mmc/mmc.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
> index 9dce540..9c96033 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/mmc.txt
> @@ -34,8 +34,8 @@ Optional properties:
>  - cap-power-off-card: powering off the card is safe
>  - cap-sdio-irq: enable SDIO IRQ signalling on this interface
>  - full-pwr-cycle: full power cycle of the card is supported
> -- mmc-highspeed-ddr-1_8v: eMMC high-speed DDR mode(1.8V I/O) is supported
> -- mmc-highspeed-ddr-1_2v: eMMC high-speed DDR mode(1.2V I/O) is supported
> +- mmc-ddr-1_8v: eMMC high-speed DDR mode(1.8V I/O) is supported
> +- mmc-ddr-1_2v: eMMC high-speed DDR mode(1.2V I/O) is supported
>  - mmc-hs200-1_8v: eMMC HS200 mode(1.8V I/O) is supported
>  - mmc-hs200-1_2v: eMMC HS200 mode(1.2V I/O) is supported
>
> --
> 1.9.1
>
