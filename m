Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3GYQhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:37:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47113 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3GYQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:37:21 -0400
Date: Thu, 25 Jul 2013 09:37:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1 05/14] clk: msm: Add support for phase locked loops
 (PLLs)
Message-ID: <20130725163719.GD29694@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-6-git-send-email-sboyd@codeaurora.org>
 <6003715.TMZ71jDUbL@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6003715.TMZ71jDUbL@flatron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Tomasz Figa wrote:
> On Wednesday 24 of July 2013 17:43:33 Stephen Boyd wrote:
> > +extern struct clk *pll_clk_register(struct device *dev, struct pll_desc
> > *desc, +		struct clk_init_data *init);
> > +extern struct clk *pll_vote_clk_register(struct device *dev,
> > +		struct pll_vote_desc *desc, struct clk_init_data *init);
> 
> I don't think such generic name is good here. What about prefixing them 
> with msm_ or qcom_ string?
> 

Sure.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
