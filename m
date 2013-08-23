Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3HWEcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:32:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46883 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3HWEcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:32:50 -0400
Date: Thu, 22 Aug 2013 21:32:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        Heiko St??bner <heiko@sntech.de>, devicetree-discuss@lists.ozlabs.org,
        Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/5] clk: dt: bindings for mux, divider & gate clocks
Message-ID: <20130823043248.GF23960@codeaurora.org>
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
 <51E8586C.7040808@codeaurora.org>
 <20130822041448.8231.16182@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822041448.8231.16182@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Mike Turquette wrote:
> 
> I just happened across a to-do list note telling me to respond to this
> email. Better late than never.
> 
[snip]
>
> This is a way to establish initial configuration from the consumer's
> perspective. Similarly something can be done for the clock rate with
> assigned-clock-rate.

Ok. Thanks for the information. Unfortunately it isn't what I
thought it was.

> 
> With all of that said this is consumer-level stuff. We'll definitely
> talk about the clock provider DT bindings at the ARM Summit, which is
> what you discuss above.

I can't wait another 2 months to start discussing the clock
provider DT bindings. We need to discuss it on the list.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
