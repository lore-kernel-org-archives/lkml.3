Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaH2NKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:10:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50282 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbaH2NKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:10:17 -0400
Message-ID: <54007BC2.4080809@mm-sol.com>
Date: Fri, 29 Aug 2014 16:10:26 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "agross@codeaurora.org" <agross@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] dt: Document Qualcomm APQ8084 pinctrl binding
References: <1409057156-1201-1-git-send-email-gdjakov@mm-sol.com> <1409057156-1201-3-git-send-email-gdjakov@mm-sol.com> <20140829060941.GH12494@sonymobile.com>
In-Reply-To: <20140829060941.GH12494@sonymobile.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 09:09 AM, Bjorn Andersson wrote:
> On Tue 26 Aug 05:45 PDT 2014, Georgi Djakov wrote:
> 
>> Define a new binding for the Qualcomm TLMM (Top-Level Mode Mux) based pin
>> controller inside the APQ8084.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> [...]
>> +Valid values for function are:
>> +adsp_ext, audio_ref, blsp_i2c1, blsp_i2c2, blsp_i2c3, blsp_i2c4, blsp_i2c5,
>> +blsp_i2c6, blsp_i2c7, blsp_i2c8, blsp_i2c9, blsp_i2c10, blsp_i2c11, blsp_i2c12,
>> +blsp_spi1, blsp_spi2, blsp_spi3, blsp_spi4, blsp_spi5, blsp_spi6, blsp_spi7,
>> +blsp_spi8, blsp_spi9, blsp_spi10, blsp_spi11, blsp_spi12, blsp_uart1,
>> +blsp_uart2, blsp_uart3, blsp_uart4, blsp_uart5, blsp_uart6, blsp_uart7,
>> +blsp_uart8, blsp_uart9, blsp_uart10, blsp_uart11, blsp_uart12, blsp_uim1,
>> +blsp_uim2, blsp_uim3, blsp_uim4, blsp_uim5, blsp_uim6, blsp_uim7, blsp_uim8,
>> +blsp_uim9, blsp_uim10, blsp_uim11, blsp_uim12, cam_mclk0, cam_mclk1, cam_mclk2,
>> +cam_mclk3, cci_async, cci_async_in0, cci_i2c0, cci_i2c1, cci_timer0, cci_timer1,
>> +cci_timer2, cci_timer3, cci_timer4, edp_hpd, gcc_gp1, gcc_gp2, gcc_gp3, gcc_obt,
>> +gcc_vtt, gp_mn, gp_pdm0, gp_pdm1, gp_pdm2, gp0_clk, gp1_clk, gpio, hdmi_cec,
>> +hdmi_ddc, hdmi_dtest, hdmi_hpd, hdmi_rcv, hsic, ldo_en, ldo_update, mdp_vsync,
>> +pci_e0, pci_e0_n, pci_e0_rst, pci_e1, pci_e1_rst, pci_e1_rst_n, pci_e1_clkreq_n,
>> +pri_mi2s, qua_mi2s, sata_act, sata_devsleep, sata_devsleep_n, sd_write,
>> +sdc_emmc_mode, sdc3, sdc4, sec_mi2s, slimbus, spdif_tx, spkr_i2s, spkr_i2s_ws,
>> +spss_geni, ter_mi2s, tsif1, tsif2, uim, uim_batt_alarm, gpio
> 
> It would be nice if these where indented.
> 
> Also, the last binding I sent up was for msm8960, where I got some comments
> that made me change the format completely. I don't require you to follow that
> instead, but I have to vent my opinion saying that it would be nice if you
> did ;)
> 

Oh, sorry for missing that and thank you for pointing it out! I will update
and resend.

BR,
Georgi
