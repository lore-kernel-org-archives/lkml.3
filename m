Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967456AbaFQWAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:00:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39429 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966027AbaFQWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:00:20 -0400
Date: Tue, 17 Jun 2014 17:00:17 -0500
From: Andy Gross <agross@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: msm: Add msm8960 definitions
Message-ID: <20140617220017.GA17864@qualcomm.com>
References: <1402424723-9659-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402424723-9659-1-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:25:23AM -0700, Bjorn Andersson wrote:

In general, it all looks good.  I only have 2 areas of concern.  The first is a
nit and it has to do with alternate pins for functions.  There really isn't a
need for a separate function name.  That would only be required if the same pin
had multiple functions defined for the same thing.

As for the second area of concern, there are some discrepancies between our
internal function map and yours.  This is probably due to some minor difference
in chip rev.  I'll try to find more information on this and determine if that is
true, or if one set of documentation is incorrect.

Now for the comments:


> +	FUNCTION(cam_mclk1),
> +	FUNCTION(cam_mclk2),
> +	FUNCTION(codec_mic_i2s),
> +	FUNCTION(codec_spkr_i2s),
> +	FUNCTION(ext_gps),
> +	FUNCTION(fm),
> +	FUNCTION(gps_blanking),
> +	FUNCTION(gps_pps_in),
> +	FUNCTION(gps_pps_out),
> +	FUNCTION(gp_clk_0a),
> +	FUNCTION(gp_clk_0b),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gp_clk_1a),
> +	FUNCTION(gp_clk_1b),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gp_clk_2a),
> +	FUNCTION(gp_clk_2b),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gp_mn),
> +	FUNCTION(gp_pdm_0a),
> +	FUNCTION(gp_pdm_0b),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gp_pdm_1a),
> +	FUNCTION(gp_pdm_1b),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gp_pdm_2a),
> +	FUNCTION(gp_pdm_2b),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gsbi1),
> +	FUNCTION(gsbi1_spi_cs1_n),
> +	FUNCTION(gsbi1_spi_cs2a_n),
> +	FUNCTION(gsbi1_spi_cs2b_n),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gsbi1_spi_cs3_n),
> +	FUNCTION(gsbi2),
> +	FUNCTION(gsbi2_spi_cs1_n),
> +	FUNCTION(gsbi2_spi_cs2_n),
> +	FUNCTION(gsbi2_spi_cs3_n),
> +	FUNCTION(gsbi3),
> +	FUNCTION(gsbi4),
> +	FUNCTION(gsbi4_3d_cam_i2c_l),
> +	FUNCTION(gsbi4_3d_cam_i2c_r),
> +	FUNCTION(gsbi5),
> +	FUNCTION(gsbi5_3d_cam_i2c_l),
> +	FUNCTION(gsbi5_3d_cam_i2c_r),
> +	FUNCTION(gsbi6),
> +	FUNCTION(gsbi7),
> +	FUNCTION(gsbi8),
> +	FUNCTION(gsbi9),
> +	FUNCTION(gsbi10),
> +	FUNCTION(gsbi11),
> +	FUNCTION(gsbi11_spi_cs1a_n),
> +	FUNCTION(gsbi11_spi_cs1b_n),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gsbi11_spi_cs2a_n),
> +	FUNCTION(gsbi11_spi_cs2b_n),

No need for a vs b, it's just alternate on different pin

> +	FUNCTION(gsbi11_spi_cs3_n),
> +	FUNCTION(gsbi12),
> +	FUNCTION(hdmi_cec),
> +	FUNCTION(hdmi_ddc_clock),

<snip>

> +	FUNCTION(usb_fs2),
> +	FUNCTION(usb_fs2_oe),
> +	FUNCTION(usb_fs2_oe_n),
> +	FUNCTION(vfe_camif_timer1_a),
> +	FUNCTION(vfe_camif_timer1_b),

why _a/_b? These are never on same pin, so it's just alternate assignment for
this function.

> +	FUNCTION(vfe_camif_timer2),
> +	FUNCTION(vfe_camif_timer3_a),
> +	FUNCTION(vfe_camif_timer3_b),

why _a/_b?  

> +	FUNCTION(vfe_camif_timer4_a),
> +	FUNCTION(vfe_camif_timer4_b),

why _a/_b?  

> +	FUNCTION(vfe_camif_timer4_c),
> +	FUNCTION(vfe_camif_timer5_a),
> +	FUNCTION(vfe_camif_timer5_b),

why _a/_b?  

> +	FUNCTION(vfe_camif_timer6_a),
> +	FUNCTION(vfe_camif_timer6_b),
> +	FUNCTION(vfe_camif_timer6_c),

why _a/_b/_c?

> +	FUNCTION(vfe_camif_timer7_a),
> +	FUNCTION(vfe_camif_timer7_b),
> +	FUNCTION(vfe_camif_timer7_c),

why _a/_b/_c?  
> +	FUNCTION(wlan),
> +};
> +
> +static const struct msm_pingroup msm8960_groups[] = {
> +	PINGROUP(0, mdp_vsync, vfe_camif_timer6_b, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(1, mdp_vsync, vfe_camif_timer7_b, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(2, vfe_camif_timer1_a, gp_mn, NA, cam_mclk2, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(3, vfe_camif_timer2, gp_clk_0a, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(4, vfe_camif_timer3_a, cam_mclk1, gp_clk_1a, pmb_ext_ctrl, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(5, cam_mclk0, pmb_ext_ctrl, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(6, gsbi1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(7, gsbi1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(8, gsbi1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(9, gsbi1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(10, gsbi2, ssbi_ts, NA, vfe_camif_timer4_c, NA, NA, NA, NA, NA, NA, NA),

gsb12, ssbi_ts, vfe_camif_timer8, NA, NA, .......

> +	PINGROUP(11, gsbi2, ts_eoc, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(12, gsbi2, rpm_wdog, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(13, gsbi2, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(14, gsbi3, gsbi1_spi_cs1_n, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(15, gsbi3, gsbi1_spi_cs2a_n, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(16, gsbi3, gsbi1_spi_cs3_n, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(17, gsbi3, gsbi1_spi_cs2b_n, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(18, gsbi4, gsbi11_spi_cs1b_n, NA, NA, gsbi4_3d_cam_i2c_l, vfe_camif_timer6_c, NA, NA, NA, NA, NA),

PINGROUP(18, gsbi4, gsbi11_spi_cs1b_n, vfe_camif_timer9, NA, gsbi4_3d_cam_i2c_l, NA, NA, NA, NA, NA, NA),

> +	PINGROUP(19, gsbi4, gsbi11_spi_cs2b_n, NA, mdp_vsync, NA, gsbi4_3d_cam_i2c_l, vfe_camif_timer7_c, NA, NA, NA, NA),

PINGROUP(19, gsbi4, gsbi11_spi_cs2b_n, vfe_camif_timer10, mdp_vsync, NA, gsbi4_3d_cam_i2c_l, NA, NA, NA, NA, NA),

> +	PINGROUP(20, gsbi4, gsbi4_3d_cam_i2c_r, NA, NA, NA, NA, NA, NA, NA, NA, NA),

<snip>

> +	PINGROUP(127, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(128, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(129, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),

Version I see has ssbi_qpa0

PINGROUP(129, NA, ssbi_qpa0, NA, NA, NA, NA, NA, NA, NA, NA, NA),

> +	PINGROUP(130, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(131, NA, ssbi_qpa1, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(132, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(133, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(134, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(135, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(136, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(137, gps_blanking, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(138, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(139, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(140, ssbi2, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(141, ssbi1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(142, ssbi2, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(143, ssbi1, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(144, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(145, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(146, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(147, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(148, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(149, ssbi_pmic2, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(150, hsic, NA, vfe_camif_timer4_b, NA, NA, NA, NA, NA, NA, NA, NA),

In the version I see there is no camif_timer.

PINGROUP(150, hsic, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),

> +	PINGROUP(151, hsic, NA, vfe_camif_timer3_b, NA, NA, NA, NA, NA, NA, NA, NA),

In the version I see there is no camif_timer.

PINGROUP(151, hsic, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),


<snip>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
