Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbaKUCSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:18:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36496 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbaKUCSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:18:30 -0500
Message-ID: <546EA0F4.10006@codeaurora.org>
Date: Thu, 20 Nov 2014 18:18:28 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Rajendra Nayak <rnayak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kenneth Westfield <kwestfie@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 6/7] clk: qcom: ipq: Add lpass clock controller driver
References: <1416442245-21967-1-git-send-email-sboyd@codeaurora.org> <1416442245-21967-7-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1416442245-21967-7-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 04:10 PM, Stephen Boyd wrote:
> +
> +static struct clk_regmap_div mi2s_bit_div_clk = {
> +	.reg = 0x48,
> +	.shift = 10,
> +	.width = 4,
> +	.clkr = {
> +		.enable_reg = 0x48,
> +		.enable_mask = BIT(15),

This also has a halt bit so I'll add that in the next version by
splitting this down further into a divider and a branch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

