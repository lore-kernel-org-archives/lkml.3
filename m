Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaIPVxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:53:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35450 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaIPVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:53:11 -0400
Date: Tue, 16 Sep 2014 14:53:09 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [Patch v2] clk: qcom: Add IPQ8064 PLL required for USB
Message-ID: <20140916215309.GC22593@codeaurora.org>
References: <1410901452-13519-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410901452-13519-1-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16, Andy Gross wrote:
> This patch adds the PLL0 that is required for the USB clocks to work properly.
> 
> Changes in v2: Correct table to only use pll0_vote
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---

Thanks, looks good.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
