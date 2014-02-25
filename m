Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaBYRSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:18:03 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaBYRSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:18:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/2] pinctrl: sh-pfc: r8a7791: Add alternative MSIOF pin groups
Date: Tue, 25 Feb 2014 18:19:18 +0100
Message-ID: <1907400.ponjrTNCdS@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392926021-19526-2-git-send-email-geert@linux-m68k.org>
References: <1392926021-19526-1-git-send-email-geert@linux-m68k.org> <1392926021-19526-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Thursday 20 February 2014 20:53:41 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Please see below for two small issues.

After fixing them,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/sh-pfc/pfc-r8a7791.c |  469 +++++++++++++++++++++++++++++++
>  1 file changed, 469 insertions(+)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c index 2a64589b5dc4..682ce5d51244
> 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> @@ -2049,6 +2049,92 @@ static const unsigned int msiof0_tx_pins[] = {
>  static const unsigned int msiof0_tx_mux[] = {
>  	MSIOF0_TXD_MARK,
>  };
> +
> +static const unsigned int msiof0_clk_b_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(0, 16),
> +};
> +static const unsigned int msiof0_clk_b_mux[] = {
> +	MSIOF0_SCK_B_MARK,
> +};
> +static const unsigned int msiof0_sync_b_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(0, 17),
> +};
> +static const unsigned int msiof0_sync_b_mux[] = {
> +	MSIOF0_SYNC_B_MARK,
> +};
> +static const unsigned int msiof0_ss1_b_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(0, 18),
> +};
> +static const unsigned int msiof0_ss1_b_mux[] = {
> +	MSIOF0_SS1_B_MARK,
> +};
> +static const unsigned int msiof0_ss2_b_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(0, 19),
> +};
> +static const unsigned int msiof0_ss2_b_mux[] = {
> +	MSIOF0_SS2_B_MARK,
> +};
> +static const unsigned int msiof0_rx_b_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(0, 21),
> +};
> +static const unsigned int msiof0_rx_b_mux[] = {
> +	MSIOF0_RXD_B_MARK,
> +};
> +static const unsigned int msiof0_tx_b_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(0, 20),
> +};
> +static const unsigned int msiof0_tx_b_mux[] = {
> +	MSIOF0_TXD_B_MARK,
> +};
> +
> +static const unsigned int msiof0_clk_c_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(5, 26),
> +};
> +static const unsigned int msiof0_clk_c_mux[] = {
> +	MSIOF0_SCK_C_MARK,
> +};
> +static const unsigned int msiof0_sync_c_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(5, 25),
> +};
> +static const unsigned int msiof0_sync_c_mux[] = {
> +	MSIOF0_SYNC_C_MARK,
> +};
> +static const unsigned int msiof0_ss1_c_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(5, 27),
> +};
> +static const unsigned int msiof0_ss1_c_mux[] = {
> +	MSIOF0_SS1_C_MARK,
> +};
> +static const unsigned int msiof0_ss2_c_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(5, 28),
> +};
> +static const unsigned int msiof0_ss2_c_mux[] = {
> +	MSIOF0_SS2_C_MARK,
> +};
> +static const unsigned int msiof0_rx_c_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(5, 29),
> +};
> +static const unsigned int msiof0_rx_c_mux[] = {
> +	MSIOF0_RXD_C_MARK,
> +};
> +static const unsigned int msiof0_tx_c_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(5, 30),
> +};
> +static const unsigned int msiof0_tx_c_mux[] = {
> +	MSIOF0_TXD_C_MARK,
> +};
>  /* - MSIOF1 ------------------------------------------------------------ */
> static const unsigned int msiof1_clk_pins[] = {
>  	/* SCK */
> @@ -2092,6 +2178,143 @@ static const unsigned int msiof1_tx_pins[] = {
>  static const unsigned int msiof1_tx_mux[] = {
>  	MSIOF1_TXD_MARK,
>  };
> +
> +static const unsigned int msiof1_clk_b_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(2, 29),
> +};
> +static const unsigned int msiof1_clk_b_mux[] = {
> +	MSIOF1_SCK_B_MARK,
> +};
> +static const unsigned int msiof1_sync_b_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(2, 30),
> +};
> +static const unsigned int msiof1_sync_b_mux[] = {
> +	MSIOF1_SYNC_B_MARK,
> +};
> +static const unsigned int msiof1_ss1_b_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(2, 31),
> +};
> +static const unsigned int msiof1_ss1_b_mux[] = {
> +	MSIOF1_SS1_B_MARK,
> +};
> +static const unsigned int msiof1_ss2_b_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(7, 16),
> +};
> +static const unsigned int msiof1_ss2_b_mux[] = {
> +	MSIOF1_SS2_B_MARK,
> +};
> +static const unsigned int msiof1_rx_b_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(7, 18),
> +};
> +static const unsigned int msiof1_rx_b_mux[] = {
> +	MSIOF1_RXD_B_MARK,
> +};
> +static const unsigned int msiof1_tx_b_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(7, 17),
> +};
> +static const unsigned int msiof1_tx_b_mux[] = {
> +	MSIOF1_TXD_B_MARK,
> +};
> +
> +static const unsigned int msiof1_clk_c_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(2, 15),
> +};
> +static const unsigned int msiof1_clk_c_mux[] = {
> +	MSIOF1_SCK_C_MARK,
> +};
> +static const unsigned int msiof1_sync_c_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(2, 16),
> +};
> +static const unsigned int msiof1_sync_c_mux[] = {
> +	MSIOF1_SYNC_C_MARK,
> +};
> +static const unsigned int msiof1_rx_c_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(2, 18),
> +};
> +static const unsigned int msiof1_rx_c_mux[] = {
> +	MSIOF1_RXD_C_MARK,
> +};
> +static const unsigned int msiof1_tx_c_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(2, 17),
> +};
> +static const unsigned int msiof1_tx_c_mux[] = {
> +	MSIOF1_TXD_C_MARK,
> +};
> +
> +static const unsigned int msiof1_clk_d_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(0, 28),
> +};
> +static const unsigned int msiof1_clk_d_mux[] = {
> +	MSIOF1_SCK_D_MARK,
> +};
> +static const unsigned int msiof1_sync_d_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(0, 30),
> +};
> +static const unsigned int msiof1_sync_d_mux[] = {
> +	MSIOF1_SYNC_D_MARK,
> +};
> +static const unsigned int msiof1_ss1_d_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(0, 29),
> +};
> +static const unsigned int msiof1_ss1_d_mux[] = {
> +	MSIOF1_SS1_D_MARK,
> +};
> +static const unsigned int msiof1_rx_d_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(0, 26),

This should be (0, 27).

> +};
> +static const unsigned int msiof1_rx_d_mux[] = {
> +	MSIOF1_RXD_D_MARK,
> +};
> +static const unsigned int msiof1_tx_d_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(0, 26),
> +};
> +static const unsigned int msiof1_tx_d_mux[] = {
> +	MSIOF1_TXD_D_MARK,
> +};
> +
> +static const unsigned int msiof1_clk_e_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(5, 18),
> +};
> +static const unsigned int msiof1_clk_e_mux[] = {
> +	MSIOF1_SCK_E_MARK,
> +};
> +static const unsigned int msiof1_sync_e_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(5, 19),
> +};
> +static const unsigned int msiof1_sync_e_mux[] = {
> +	MSIOF1_SYNC_E_MARK,
> +};
> +static const unsigned int msiof1_rx_e_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(5, 17),
> +};
> +static const unsigned int msiof1_rx_e_mux[] = {
> +	MSIOF1_RXD_E_MARK,
> +};
> +static const unsigned int msiof1_tx_e_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(5, 20),
> +};
> +static const unsigned int msiof1_tx_e_mux[] = {
> +	MSIOF1_TXD_E_MARK,
> +};
>  /* - MSIOF2 ------------------------------------------------------------ */
> static const unsigned int msiof2_clk_pins[] = {
>  	/* SCK */
> @@ -2135,6 +2358,150 @@ static const unsigned int msiof2_tx_pins[] = {
>  static const unsigned int msiof2_tx_mux[] = {
>  	MSIOF2_TXD_MARK,
>  };
> +
> +static const unsigned int msiof2_clk_b_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(3, 0),
> +};
> +static const unsigned int msiof2_clk_b_mux[] = {
> +	MSIOF2_SCK_B_MARK,
> +};
> +static const unsigned int msiof2_sync_b_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(3, 1),
> +};
> +static const unsigned int msiof2_sync_b_mux[] = {
> +	MSIOF2_SYNC_B_MARK,
> +};
> +static const unsigned int msiof2_ss1_b_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(3, 8),
> +};
> +static const unsigned int msiof2_ss1_b_mux[] = {
> +	MSIOF2_SS1_B_MARK,
> +};
> +static const unsigned int msiof2_ss2_b_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(3, 9),
> +};
> +static const unsigned int msiof2_ss2_b_mux[] = {
> +	MSIOF2_SS2_B_MARK,
> +};
> +static const unsigned int msiof2_rx_b_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(3, 17),
> +};
> +static const unsigned int msiof2_rx_b_mux[] = {
> +	MSIOF2_RXD_B_MARK,
> +};
> +static const unsigned int msiof2_tx_b_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(3, 16),
> +};
> +static const unsigned int msiof2_tx_b_mux[] = {
> +	MSIOF2_TXD_B_MARK,
> +};
> +
> +static const unsigned int msiof2_clk_c_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(2, 2),
> +};
> +static const unsigned int msiof2_clk_c_mux[] = {
> +	MSIOF2_SCK_C_MARK,
> +};
> +static const unsigned int msiof2_sync_c_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(2, 3),
> +};
> +static const unsigned int msiof2_sync_c_mux[] = {
> +	MSIOF2_SYNC_C_MARK,
> +};
> +static const unsigned int msiof2_rx_c_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(2, 5),
> +};
> +static const unsigned int msiof2_rx_c_mux[] = {
> +	MSIOF2_RXD_C_MARK,
> +};
> +static const unsigned int msiof2_tx_c_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(2, 4),
> +};
> +static const unsigned int msiof2_tx_c_mux[] = {
> +	MSIOF2_TXD_C_MARK,
> +};
> +
> +static const unsigned int msiof2_clk_d_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(2, 14),
> +};
> +static const unsigned int msiof2_clk_d_mux[] = {
> +	MSIOF2_SCK_D_MARK,
> +};
> +static const unsigned int msiof2_sync_d_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(2, 15),
> +};
> +static const unsigned int msiof2_sync_d_mux[] = {
> +	MSIOF2_SYNC_D_MARK,
> +};
> +static const unsigned int msiof2_ss1_d_pins[] = {
> +	/* SS1 */
> +	RCAR_GP_PIN(2, 17),
> +};
> +static const unsigned int msiof2_ss1_d_mux[] = {
> +	MSIOF2_SS1_D_MARK,
> +};
> +static const unsigned int msiof2_ss2_d_pins[] = {
> +	/* SS2 */
> +	RCAR_GP_PIN(2, 18),

This should be (2, 19).

> +};
> +static const unsigned int msiof2_ss2_d_mux[] = {
> +	MSIOF2_SS2_D_MARK,
> +};
> +static const unsigned int msiof2_rx_d_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(2, 18),
> +};
> +static const unsigned int msiof2_rx_d_mux[] = {
> +	MSIOF2_RXD_D_MARK,
> +};
> +static const unsigned int msiof2_tx_d_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(2, 16),
> +};
> +static const unsigned int msiof2_tx_d_mux[] = {
> +	MSIOF2_TXD_D_MARK,
> +};
> +
> +static const unsigned int msiof2_clk_e_pins[] = {
> +	/* SCK */
> +	RCAR_GP_PIN(7, 15),
> +};
> +static const unsigned int msiof2_clk_e_mux[] = {
> +	MSIOF2_SCK_E_MARK,
> +};
> +static const unsigned int msiof2_sync_e_pins[] = {
> +	/* SYNC */
> +	RCAR_GP_PIN(7, 16),
> +};
> +static const unsigned int msiof2_sync_e_mux[] = {
> +	MSIOF2_SYNC_E_MARK,
> +};
> +static const unsigned int msiof2_rx_e_pins[] = {
> +	/* RXD */
> +	RCAR_GP_PIN(7, 14),
> +};
> +static const unsigned int msiof2_rx_e_mux[] = {
> +	MSIOF2_RXD_E_MARK,
> +};
> +static const unsigned int msiof2_tx_e_pins[] = {
> +	/* TXD */
> +	RCAR_GP_PIN(7, 13),
> +};
> +static const unsigned int msiof2_tx_e_mux[] = {
> +	MSIOF2_TXD_E_MARK,
> +};
>  /* - QSPI -------------------------------------------------------------- */
> static const unsigned int qspi_ctrl_pins[] = {
>  	/* SPCLK, SSL */
> @@ -3184,18 +3551,69 @@ static const struct sh_pfc_pin_group pinmux_groups[]
> = { SH_PFC_PIN_GROUP(msiof0_ss2),
>  	SH_PFC_PIN_GROUP(msiof0_rx),
>  	SH_PFC_PIN_GROUP(msiof0_tx),
> +	SH_PFC_PIN_GROUP(msiof0_clk_b),
> +	SH_PFC_PIN_GROUP(msiof0_sync_b),
> +	SH_PFC_PIN_GROUP(msiof0_ss1_b),
> +	SH_PFC_PIN_GROUP(msiof0_ss2_b),
> +	SH_PFC_PIN_GROUP(msiof0_rx_b),
> +	SH_PFC_PIN_GROUP(msiof0_tx_b),
> +	SH_PFC_PIN_GROUP(msiof0_clk_c),
> +	SH_PFC_PIN_GROUP(msiof0_sync_c),
> +	SH_PFC_PIN_GROUP(msiof0_ss1_c),
> +	SH_PFC_PIN_GROUP(msiof0_ss2_c),
> +	SH_PFC_PIN_GROUP(msiof0_rx_c),
> +	SH_PFC_PIN_GROUP(msiof0_tx_c),
>  	SH_PFC_PIN_GROUP(msiof1_clk),
>  	SH_PFC_PIN_GROUP(msiof1_sync),
>  	SH_PFC_PIN_GROUP(msiof1_ss1),
>  	SH_PFC_PIN_GROUP(msiof1_ss2),
>  	SH_PFC_PIN_GROUP(msiof1_rx),
>  	SH_PFC_PIN_GROUP(msiof1_tx),
> +	SH_PFC_PIN_GROUP(msiof1_clk_b),
> +	SH_PFC_PIN_GROUP(msiof1_sync_b),
> +	SH_PFC_PIN_GROUP(msiof1_ss1_b),
> +	SH_PFC_PIN_GROUP(msiof1_ss2_b),
> +	SH_PFC_PIN_GROUP(msiof1_rx_b),
> +	SH_PFC_PIN_GROUP(msiof1_tx_b),
> +	SH_PFC_PIN_GROUP(msiof1_clk_c),
> +	SH_PFC_PIN_GROUP(msiof1_sync_c),
> +	SH_PFC_PIN_GROUP(msiof1_rx_c),
> +	SH_PFC_PIN_GROUP(msiof1_tx_c),
> +	SH_PFC_PIN_GROUP(msiof1_clk_d),
> +	SH_PFC_PIN_GROUP(msiof1_sync_d),
> +	SH_PFC_PIN_GROUP(msiof1_ss1_d),
> +	SH_PFC_PIN_GROUP(msiof1_rx_d),
> +	SH_PFC_PIN_GROUP(msiof1_tx_d),
> +	SH_PFC_PIN_GROUP(msiof1_clk_e),
> +	SH_PFC_PIN_GROUP(msiof1_sync_e),
> +	SH_PFC_PIN_GROUP(msiof1_rx_e),
> +	SH_PFC_PIN_GROUP(msiof1_tx_e),
>  	SH_PFC_PIN_GROUP(msiof2_clk),
>  	SH_PFC_PIN_GROUP(msiof2_sync),
>  	SH_PFC_PIN_GROUP(msiof2_ss1),
>  	SH_PFC_PIN_GROUP(msiof2_ss2),
>  	SH_PFC_PIN_GROUP(msiof2_rx),
>  	SH_PFC_PIN_GROUP(msiof2_tx),
> +	SH_PFC_PIN_GROUP(msiof2_clk_b),
> +	SH_PFC_PIN_GROUP(msiof2_sync_b),
> +	SH_PFC_PIN_GROUP(msiof2_ss1_b),
> +	SH_PFC_PIN_GROUP(msiof2_ss2_b),
> +	SH_PFC_PIN_GROUP(msiof2_rx_b),
> +	SH_PFC_PIN_GROUP(msiof2_tx_b),
> +	SH_PFC_PIN_GROUP(msiof2_clk_c),
> +	SH_PFC_PIN_GROUP(msiof2_sync_c),
> +	SH_PFC_PIN_GROUP(msiof2_rx_c),
> +	SH_PFC_PIN_GROUP(msiof2_tx_c),
> +	SH_PFC_PIN_GROUP(msiof2_clk_d),
> +	SH_PFC_PIN_GROUP(msiof2_sync_d),
> +	SH_PFC_PIN_GROUP(msiof2_ss1_d),
> +	SH_PFC_PIN_GROUP(msiof2_ss2_d),
> +	SH_PFC_PIN_GROUP(msiof2_rx_d),
> +	SH_PFC_PIN_GROUP(msiof2_tx_d),
> +	SH_PFC_PIN_GROUP(msiof2_clk_e),
> +	SH_PFC_PIN_GROUP(msiof2_sync_e),
> +	SH_PFC_PIN_GROUP(msiof2_rx_e),
> +	SH_PFC_PIN_GROUP(msiof2_tx_e),
>  	SH_PFC_PIN_GROUP(qspi_ctrl),
>  	SH_PFC_PIN_GROUP(qspi_data2),
>  	SH_PFC_PIN_GROUP(qspi_data4),
> @@ -3409,6 +3827,18 @@ static const char * const msiof0_groups[] = {
>  	"msiof0_ss2",
>  	"msiof0_rx",
>  	"msiof0_tx",
> +	"msiof0_clk_b",
> +	"msiof0_sync_b",
> +	"msiof0_ss1_b",
> +	"msiof0_ss2_b",
> +	"msiof0_rx_b",
> +	"msiof0_tx_b",
> +	"msiof0_clk_c",
> +	"msiof0_sync_c",
> +	"msiof0_ss1_c",
> +	"msiof0_ss2_c",
> +	"msiof0_rx_c",
> +	"msiof0_tx_c",
>  };
> 
>  static const char * const msiof1_groups[] = {
> @@ -3418,6 +3848,25 @@ static const char * const msiof1_groups[] = {
>  	"msiof1_ss2",
>  	"msiof1_rx",
>  	"msiof1_tx",
> +	"msiof1_clk_b",
> +	"msiof1_sync_b",
> +	"msiof1_ss1_b",
> +	"msiof1_ss2_b",
> +	"msiof1_rx_b",
> +	"msiof1_tx_b",
> +	"msiof1_clk_c",
> +	"msiof1_sync_c",
> +	"msiof1_rx_c",
> +	"msiof1_tx_c",
> +	"msiof1_clk_d",
> +	"msiof1_sync_d",
> +	"msiof1_ss1_d",
> +	"msiof1_rx_d",
> +	"msiof1_tx_d",
> +	"msiof1_clk_e",
> +	"msiof1_sync_e",
> +	"msiof1_rx_e",
> +	"msiof1_tx_e",
>  };
> 
>  static const char * const msiof2_groups[] = {
> @@ -3427,6 +3876,26 @@ static const char * const msiof2_groups[] = {
>  	"msiof2_ss2",
>  	"msiof2_rx",
>  	"msiof2_tx",
> +	"msiof2_clk_b",
> +	"msiof2_sync_b",
> +	"msiof2_ss1_b",
> +	"msiof2_ss2_b",
> +	"msiof2_rx_b",
> +	"msiof2_tx_b",
> +	"msiof2_clk_c",
> +	"msiof2_sync_c",
> +	"msiof2_rx_c",
> +	"msiof2_tx_c",
> +	"msiof2_clk_d",
> +	"msiof2_sync_d",
> +	"msiof2_ss1_d",
> +	"msiof2_ss2_d",
> +	"msiof2_rx_d",
> +	"msiof2_tx_d",
> +	"msiof2_clk_e",
> +	"msiof2_sync_e",
> +	"msiof2_rx_e",
> +	"msiof2_tx_e",
>  };
> 
>  static const char * const qspi_groups[] = {

-- 
Regards,

Laurent Pinchart

