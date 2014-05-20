Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaETRiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:38:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34706 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaETRiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:38:02 -0400
Message-ID: <537B92F8.90903@codeaurora.org>
Date: Tue, 20 May 2014 10:38:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Fix blsp2_ahb_clk register offset
References: <1400604654-27701-1-git-send-email-gdjakov@mm-sol.com>
In-Reply-To: <1400604654-27701-1-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/14 09:50, Georgi Djakov wrote:
> The address of the blsp2_ahb_clk register is incorrect. Fix it.
>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Hmph. Looks like I did a bad copy/paste. Thanks.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

