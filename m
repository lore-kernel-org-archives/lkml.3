Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBYBjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:39:53 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60692 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaBYBjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:39:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: pfc: r8a7791: add mux data for IIC(B) cores
Date: Tue, 25 Feb 2014 02:41:09 +0100
Message-ID: <6968383.4dKPvQRapR@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393159095-14269-1-git-send-email-wsa@the-dreams.de>
References: <1393159095-14269-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thank you for the patch.

On Sunday 23 February 2014 13:38:12 Wolfram Sang wrote:
> From: Wolfram Sang <wsa@sang-engineering.com>
> 
> Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 64 +++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c index 77d103f..cd28cec 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> @@ -1943,6 +1943,50 @@ static const unsigned int i2c4_c_pins[] = {
>  static const unsigned int i2c4_c_mux[] = {
>  	SCL4_C_MARK, SDA4_C_MARK,
>  };
> +/* - I2C7 -------------------------------------------------------------- */
> +static const unsigned int i2c7_pins[] = {
> +	/* SCL, SDA */
> +	RCAR_GP_PIN(5, 15), RCAR_GP_PIN(5, 16),
> +};
> +static const unsigned int i2c7_mux[] = {
> +	SCL7_MARK, SDA7_MARK,
> +};
> +static const unsigned int i2c7_b_pins[] = {
> +	/* SCL, SDA */
> +	RCAR_GP_PIN(2, 2), RCAR_GP_PIN(2, 3),
> +};
> +static const unsigned int i2c7_b_mux[] = {
> +	SCL7_B_MARK, SDA7_B_MARK,
> +};
> +static const unsigned int i2c7_c_pins[] = {
> +	/* SCL, SDA */
> +	RCAR_GP_PIN(6, 28), RCAR_GP_PIN(6, 29),
> +};
> +static const unsigned int i2c7_c_mux[] = {
> +	SCL7_C_MARK, SDA7_C_MARK,
> +};
> +/* - I2C8 -------------------------------------------------------------- */
> +static const unsigned int i2c8_pins[] = {
> +	/* SCL, SDA */
> +	RCAR_GP_PIN(4, 13), RCAR_GP_PIN(4, 14),
> +};
> +static const unsigned int i2c8_mux[] = {
> +	SCL8_MARK, SDA8_MARK,
> +};
> +static const unsigned int i2c8_b_pins[] = {
> +	/* SCL, SDA */
> +	RCAR_GP_PIN(2, 4), RCAR_GP_PIN(2, 5),
> +};
> +static const unsigned int i2c8_b_mux[] = {
> +	SCL8_B_MARK, SDA8_B_MARK,
> +};
> +static const unsigned int i2c8_c_pins[] = {
> +	/* SCL, SDA */
> +	RCAR_GP_PIN(6, 22), RCAR_GP_PIN(6, 23),
> +};
> +static const unsigned int i2c8_c_mux[] = {
> +	SCL8_C_MARK, SDA8_C_MARK,
> +};
>  /* - INTC -------------------------------------------------------------- */
> static const unsigned int intc_irq0_pins[] = {
>  	/* IRQ */
> @@ -3123,6 +3167,12 @@ static const struct sh_pfc_pin_group pinmux_groups[]
> = { SH_PFC_PIN_GROUP(i2c4),
>  	SH_PFC_PIN_GROUP(i2c4_b),
>  	SH_PFC_PIN_GROUP(i2c4_c),
> +	SH_PFC_PIN_GROUP(i2c7),
> +	SH_PFC_PIN_GROUP(i2c7_b),
> +	SH_PFC_PIN_GROUP(i2c7_c),
> +	SH_PFC_PIN_GROUP(i2c8),
> +	SH_PFC_PIN_GROUP(i2c8_b),
> +	SH_PFC_PIN_GROUP(i2c8_c),
>  	SH_PFC_PIN_GROUP(intc_irq0),
>  	SH_PFC_PIN_GROUP(intc_irq1),
>  	SH_PFC_PIN_GROUP(intc_irq2),
> @@ -3335,6 +3385,18 @@ static const char * const i2c4_groups[] = {
>  	"i2c4_c",
>  };
> 
> +static const char * const i2c7_groups[] = {
> +	"i2c7",
> +	"i2c7_b",
> +	"i2c7_c",
> +};
> +
> +static const char * const i2c8_groups[] = {
> +	"i2c8",
> +	"i2c8_b",
> +	"i2c8_c",
> +};
> +
>  static const char * const intc_groups[] = {
>  	"intc_irq0",
>  	"intc_irq1",
> @@ -3566,6 +3628,8 @@ static const struct sh_pfc_function pinmux_functions[]
> = { SH_PFC_FUNCTION(i2c2),
>  	SH_PFC_FUNCTION(i2c3),
>  	SH_PFC_FUNCTION(i2c4),
> +	SH_PFC_FUNCTION(i2c7),
> +	SH_PFC_FUNCTION(i2c8),
>  	SH_PFC_FUNCTION(intc),
>  	SH_PFC_FUNCTION(mmc),
>  	SH_PFC_FUNCTION(msiof0),

-- 
Regards,

Laurent Pinchart

