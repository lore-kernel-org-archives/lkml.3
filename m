Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaEOGr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:47:59 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56887 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaEOGo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:44:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Fabio Estevam <festevam@gmail.com>, robh+dt@kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399604510-3043-1-git-send-email-festevam@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Fabio Estevam" <fabio.estevam@freescale.com>
References: <1399604510-3043-1-git-send-email-festevam@gmail.com>
Message-ID: <20140515064420.9521.47383@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH RESEND] Documentation: clock: fixed-clock: Remove unsupported
 'gpios' property
Date: Wed, 14 May 2014 23:44:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Fabio Estevam (2014-05-08 20:01:50)
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Remove the 'gpios' property from the documentation as this is something that the
> current fixed clock driver does not handle.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Good catch. Taken into clk-next.

Regards,
Mike

> ---
>  Documentation/devicetree/bindings/clock/fixed-clock.txt | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/fixed-clock.txt b/Documentation/devicetree/bindings/clock/fixed-clock.txt
> index 48ea0ad..0641a663 100644
> --- a/Documentation/devicetree/bindings/clock/fixed-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
> @@ -12,7 +12,6 @@ Required properties:
>  Optional properties:
>  - clock-accuracy : accuracy of clock in ppb (parts per billion).
>                    Should be a single cell.
> -- gpios : From common gpio binding; gpio connection to clock enable pin.
>  - clock-output-names : From common clock binding.
>  
>  Example:
> -- 
> 1.8.3.2
> 
