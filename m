Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaJKAQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 20:16:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52932 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaJKAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 20:16:35 -0400
Date: Fri, 10 Oct 2014 17:16:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Fix duplicate rbcpr clock name
Message-ID: <20141011001632.GI5493@codeaurora.org>
References: <1412949444-9792-1-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412949444-9792-1-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Georgi Djakov wrote:
> There is a duplication in a clock name for apq8084 platform that causes
> the following warning: "RBCPR_CLK_SRC" redefined
> 
> Resolve this by adding a MMSS_ prefix to this clock and making its name
> coherent with msm8974 platform.
> 
> Fixes: 2b46cd23a5a2 ("clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support")
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

It would be nice if we could somehow detect this sort of problem
automatically.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
