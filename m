Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaAOTED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:04:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51151 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaAOTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:03:59 -0500
Date: Wed, 15 Jan 2014 11:03:58 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 02/15] clk: Allow drivers to pass in a regmap
Message-ID: <20140115190358.GA26193@codeaurora.org>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-3-git-send-email-sboyd@codeaurora.org>
 <20140109015158.7168.60274@quantum>
 <52CE055C.5030103@codeaurora.org>
 <20140110054424.7168.46289@quantum>
 <20140110070517.GE14405@codeaurora.org>
 <20140115092857.4167.38854@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115092857.4167.38854@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Mike Turquette wrote:
> 
> So in summary: consolidation is over-rated. You can put your regmap
> functions into drivers/clk/msm/ and not convert over to struct clk_desc
> by the way, just to remove any confusion on that point.
> 

Ok I've made the wrapper struct clk_regmap and posted the
patches. I think I've addressed all your concerns.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
