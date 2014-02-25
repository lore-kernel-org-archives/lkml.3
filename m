Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaBYRFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:05:52 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37335 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaBYRFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:05:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 1/2] pinctrl: sh-pfc: r8a7790: Add alternative MSIOF pin groups
Date: Tue, 25 Feb 2014 18:07:08 +0100
Message-ID: <2539875.LC3GLXFbLI@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392926021-19526-1-git-send-email-geert@linux-m68k.org>
References: <1392926021-19526-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Thursday 20 February 2014 20:53:40 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

I'm a bit concerned that this would allow boards to select combinations of 
main and alternate MSIOF pins not supported by the hardware, but there's 
little we can do about that, so

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/sh-pfc/pfc-r8a7790.c |  129 +++++++++++++++++++++++++++++++
>  1 file changed, 129 insertions(+)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c index 2ca319f15d31..2d1a0a158682
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
> @@ -2260,6 +2260,42 @@ static const unsigned int msiof0_tx_pins[] = {
>  static const unsigned int msiof0_tx_mux[] = {
>  	MSIOF0_TXD_MARK,
>  };
> +
> +static const unsigned int msiof0_clk_b_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(1, 23),
> +};
> +static const unsigned int msiof0_clk_b_mux[] = {
> +	MSIOF0_SCK_B_MARK,
> +};
> +static const unsigned int msiof0_ss1_b_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(1, 12),
> +};
> +static const unsigned int msiof0_ss1_b_mux[] = {
> +	MSIOF0_SS1_B_MARK,
> +};
> +static const unsigned int msiof0_ss2_b_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(1, 10),
> +};
> +static const unsigned int msiof0_ss2_b_mux[] = {
> +	MSIOF0_SS2_B_MARK,
> +};
> +static const unsigned int msiof0_rx_b_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(1, 29),
> +};
> +static const unsigned int msiof0_rx_b_mux[] = {
> +	MSIOF0_RXD_B_MARK,
> +};
> +static const unsigned int msiof0_tx_b_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(1, 28),
> +};
> +static const unsigned int msiof0_tx_b_mux[] = {
> +	MSIOF0_TXD_B_MARK,
> +};
>  /* - MSIOF1
> ----------------------------------------------------------------- */ static
> const unsigned int msiof1_clk_pins[] = {
>  	/* SCK */
> @@ -2303,6 +2339,42 @@ static const unsigned int msiof1_tx_pins[] = {
>  static const unsigned int msiof1_tx_mux[] = {
>  	MSIOF1_TXD_MARK,
>  };
> +
> +static const unsigned int msiof1_clk_b_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(1, 16),
> +};
> +static const unsigned int msiof1_clk_b_mux[] = {
> +	MSIOF1_SCK_B_MARK,
> +};
> +static const unsigned int msiof1_ss1_b_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(0, 18),
> +};
> +static const unsigned int msiof1_ss1_b_mux[] = {
> +	MSIOF1_SS1_B_MARK,
> +};
> +static const unsigned int msiof1_ss2_b_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(0, 19),
> +};
> +static const unsigned int msiof1_ss2_b_mux[] = {
> +	MSIOF1_SS2_B_MARK,
> +};
> +static const unsigned int msiof1_rx_b_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(1, 17),
> +};
> +static const unsigned int msiof1_rx_b_mux[] = {
> +	MSIOF1_RXD_B_MARK,
> +};
> +static const unsigned int msiof1_tx_b_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(0, 20),
> +};
> +static const unsigned int msiof1_tx_b_mux[] = {
> +	MSIOF1_TXD_B_MARK,
> +};
>  /* - MSIOF2
> ----------------------------------------------------------------- */ static
> const unsigned int msiof2_clk_pins[] = {
>  	/* SCK */
> @@ -2389,6 +2461,35 @@ static const unsigned int msiof3_tx_pins[] = {
>  static const unsigned int msiof3_tx_mux[] = {
>  	MSIOF3_TXD_MARK,
>  };
> +
> +static const unsigned int msiof3_clk_b_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(0, 0),
> +};
> +static const unsigned int msiof3_clk_b_mux[] = {
> +	MSIOF3_SCK_B_MARK,
> +};
> +static const unsigned int msiof3_sync_b_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(0, 1),
> +};
> +static const unsigned int msiof3_sync_b_mux[] = {
> +	MSIOF3_SYNC_B_MARK,
> +};
> +static const unsigned int msiof3_rx_b_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(0, 2),
> +};
> +static const unsigned int msiof3_rx_b_mux[] = {
> +	MSIOF3_RXD_B_MARK,
> +};
> +static const unsigned int msiof3_tx_b_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(0, 3),
> +};
> +static const unsigned int msiof3_tx_b_mux[] = {
> +	MSIOF3_TXD_B_MARK,
> +};
>  /* - QSPI
> ------------------------------------------------------------------- */
> static const unsigned int qspi_ctrl_pins[] = {
>  	/* SPCLK, SSL */
> @@ -3676,12 +3777,22 @@ static const struct sh_pfc_pin_group pinmux_groups[]
> = { SH_PFC_PIN_GROUP(msiof0_ss2),
>  	SH_PFC_PIN_GROUP(msiof0_rx),
>  	SH_PFC_PIN_GROUP(msiof0_tx),
> +	SH_PFC_PIN_GROUP(msiof0_clk_b),
> +	SH_PFC_PIN_GROUP(msiof0_ss1_b),
> +	SH_PFC_PIN_GROUP(msiof0_ss2_b),
> +	SH_PFC_PIN_GROUP(msiof0_rx_b),
> +	SH_PFC_PIN_GROUP(msiof0_tx_b),
>  	SH_PFC_PIN_GROUP(msiof1_clk),
>  	SH_PFC_PIN_GROUP(msiof1_sync),
>  	SH_PFC_PIN_GROUP(msiof1_ss1),
>  	SH_PFC_PIN_GROUP(msiof1_ss2),
>  	SH_PFC_PIN_GROUP(msiof1_rx),
>  	SH_PFC_PIN_GROUP(msiof1_tx),
> +	SH_PFC_PIN_GROUP(msiof1_clk_b),
> +	SH_PFC_PIN_GROUP(msiof1_ss1_b),
> +	SH_PFC_PIN_GROUP(msiof1_ss2_b),
> +	SH_PFC_PIN_GROUP(msiof1_rx_b),
> +	SH_PFC_PIN_GROUP(msiof1_tx_b),
>  	SH_PFC_PIN_GROUP(msiof2_clk),
>  	SH_PFC_PIN_GROUP(msiof2_sync),
>  	SH_PFC_PIN_GROUP(msiof2_ss1),
> @@ -3694,6 +3805,10 @@ static const struct sh_pfc_pin_group pinmux_groups[]
> = { SH_PFC_PIN_GROUP(msiof3_ss2),
>  	SH_PFC_PIN_GROUP(msiof3_rx),
>  	SH_PFC_PIN_GROUP(msiof3_tx),
> +	SH_PFC_PIN_GROUP(msiof3_clk_b),
> +	SH_PFC_PIN_GROUP(msiof3_sync_b),
> +	SH_PFC_PIN_GROUP(msiof3_rx_b),
> +	SH_PFC_PIN_GROUP(msiof3_tx_b),
>  	SH_PFC_PIN_GROUP(qspi_ctrl),
>  	SH_PFC_PIN_GROUP(qspi_data2),
>  	SH_PFC_PIN_GROUP(qspi_data4),
> @@ -3967,6 +4082,11 @@ static const char * const msiof0_groups[] = {
>  	"msiof0_ss2",
>  	"msiof0_rx",
>  	"msiof0_tx",
> +	"msiof0_clk_b",
> +	"msiof0_ss1_b",
> +	"msiof0_ss2_b",
> +	"msiof0_rx_b",
> +	"msiof0_tx_b",
>  };
> 
>  static const char * const msiof1_groups[] = {
> @@ -3976,6 +4096,11 @@ static const char * const msiof1_groups[] = {
>  	"msiof1_ss2",
>  	"msiof1_rx",
>  	"msiof1_tx",
> +	"msiof1_clk_b",
> +	"msiof1_ss1_b",
> +	"msiof1_ss2_b",
> +	"msiof1_rx_b",
> +	"msiof1_tx_b",
>  };
> 
>  static const char * const msiof2_groups[] = {
> @@ -3994,6 +4119,10 @@ static const char * const msiof3_groups[] = {
>  	"msiof3_ss2",
>  	"msiof3_rx",
>  	"msiof3_tx",
> +	"msiof3_clk_b",
> +	"msiof3_sync_b",
> +	"msiof3_rx_b",
> +	"msiof3_tx_b",
>  };
> 
>  static const char * const qspi_groups[] = {

-- 
Regards,

Laurent Pinchart

