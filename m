Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbbA0RUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:20:32 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16544 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbbA0RUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:20:30 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Tue, 27 Jan 2015 09:20:24 -0800
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Joonwoo Park <joonwoop@codeaurora.org>
Subject: Re: [PATCH 2/3] DT: pinctrl: Document Qualcomm MSM8916 pinctrl
 binding
Message-ID: <20150127172023.GD11960@sonymobile.com>
References: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
 <1421745476-6276-3-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1421745476-6276-3-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20 Jan 01:17 PST 2015, Stanimir Varbanov wrote:

> Adds devicetree binding documentation.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
[..]

> +- function:
> +	Usage: required
> +	Value type: <string>
> +	Definition: Specify the alternative function to be configured for the
> +		    specified pins. Functions are only valid for gpio pins.
> +		    Valid values are:
> +	adsp_ext, alsp_int, atest_bbrx0, atest_bbrx1, atest_char, atest_char0,
> +	atest_char1, atest_char2, atest_char3, atest_combodac, atest_gpsadc0,
> +	atest_gpsadc1, atest_tsens, atest_wlan0, atest_wlan1, backlight_en,
> +	bimc_dte0, bimc_dte1, blsp1_spi, blsp2_spi, blsp3_spi, blsp_i2c1,
> +	blsp_i2c2, blsp_i2c3, blsp_i2c4, blsp_i2c5, blsp_i2c6, blsp_spi1,
> +	blsp_spi2, blsp_spi3, blsp_spi4, blsp_spi5, blsp_spi6, blsp_uart1,
> +	blsp_uart2, blsp_uim1, blsp_uim2, cam1_rst, cam1_standby, cam_mclk,
> +	cci_async, cci_i2c, cci_timer0, cci_timer1, cci_timer2, cdc_pdm0,
> +	codec_mad, dbg_out, display_5v, dmic0_clk, dmic0_data, dsi_rst,
> +	ebi0_wrcdc, euro_us, ext_lpass, flash_strobe, gcc_gp1_clk_a,
> +	gcc_gp1_clk_b, gcc_gp2_clk_a, gcc_gp2_clk_b, gcc_gp3_clk_a,
> +	gcc_gp3_clk_b, gpio, gsm0_tx0, gsm0_tx1, gsm1_tx0, gsm1_tx1, gyro_accl,
> +	kpsns0, kpsns1, kpsns2, ldo_en, ldo_update, mag_int, mdp_vsync,
> +	modem_tsync, m_voc, nav_pps, nav_tsync, pa_indicator, pbs0, pbs1, pbs2,
> +	pri_mi2s, pri_mi2s_ws, prng_rosc, pwr_crypto_enabled_a,
> +	pwr_crypto_enabled_b, pwr_modem_enabled_a, pwr_modem_enabled_b,
> +	pwr_nav_enabled_a, pwr_nav_enabled_b, qdss_cti_trig_in_a0,
> +	qdss_cti_trig_in_a1, qdss_cti_trig_in_b0, qdss_cti_trig_in_b1,
> +	qdss_cti_trig_out_a0, qdss_cti_trig_out_a1, qdss_cti_trig_out_b0,
> +	qdss_cti_trig_out_b1, qdss_traceclk_a, qdss_traceclk_b, qdss_tracectl_a,
> +	qdss_tracectl_b, qdss_tracedata_a, qdss_tracedata_b, reset_n, sd_card,
> +	sd_write, sec_mi2s, smb_int, ssbi_wtr0, ssbi_wtr1, uim1_clk, uim1_data,
> +	uim1_present, uim1_reset, uim2_clk, uim2_data, uim2_present, uim2_reset,
> +	uim3_clk, uim3_data, uim3_present, uim3_reset, uim_batt, wcss_bt,
> +	wcss_fm, wcss_wlan, wcss_wlan0, wcss_wlan1, wcss_wlan2, webcam1_rst,
> +

Looks reasonable, but unfortunately my 8916 documentation is incomplete so I
can't review this part.

The rest is:
Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
