Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaIOSS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:18:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44949 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaIOSSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:18:25 -0400
Message-ID: <54172D6C.10902@codeaurora.org>
Date: Mon, 15 Sep 2014 11:18:20 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Mike Turquette <mturquette@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH] clk: qcom: Add IPQ8064 PLL required for USB
References: <1410754332-26699-1-git-send-email-agross@codeaurora.org>
In-Reply-To: <1410754332-26699-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/14 21:12, Andy Gross wrote:
>  static struct clk_pll pll3 = {
>  	.l_reg = 0x3164,
>  	.m_reg = 0x3168,
> @@ -155,6 +182,7 @@ static const char *gcc_pxo_pll8_pll0_map[] = {
>  	"pxo",
>  	"pll8_vote",
>  	"pll0",
> +	"pll0_vote",
>  };

This is wrong. We should be removing pll0 and adding pll0_vote.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

