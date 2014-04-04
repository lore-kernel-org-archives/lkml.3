Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaDDSTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:19:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57913 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaDDSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:19:00 -0400
Message-ID: <533EF793.3050104@codeaurora.org>
Date: Fri, 04 Apr 2014 11:18:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Mike Turquette <mturquette@linaro.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Various fixes for MSM8960's global clock controller
References: <1396629176-7413-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396629176-7413-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 09:32, Kumar Gala wrote:
> * Remove CE2_SLEEP_CLK, doesn't exist on 8960 family SoCs
> * Fix incorrect offset for PMIC_SSBI2_RESET
> * Fix typo:
> 	SIC_TIC -> SPS_TIC_H
> 	SFAB_ADM0_M2_A_CLK -> SFAB_ADM0_M2_H_CLK
> * Fix naming convention:
> 	SFAB_CFPB_S_HCLK -> SFAB_CFPB_S_H_CLK
> 	SATA_SRC_CLK -> SATA_CLK_SRC
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>

Thanks

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

