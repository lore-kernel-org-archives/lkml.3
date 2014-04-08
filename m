Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaDHAdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:33:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49391 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDHAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:33:06 -0400
Date: Mon, 7 Apr 2014 17:33:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] clk: qcom: Add support for IPQ8064's global clock
 controller (GCC)
Message-ID: <20140408003304.GK9985@codeaurora.org>
References: <1396642749-12979-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396642749-12979-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Kumar Gala wrote:
> Add a driver for the global clock controller found on IPQ8064 based
> platforms. This should allow most non-multimedia device drivers to probe
> and control their clocks.
> 
> This is currently missing clocks for SATA, USB, and networking devices.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
