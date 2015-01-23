Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbbAWKfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:35:13 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:34223 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbAWKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:35:09 -0500
Date: Fri, 23 Jan 2015 10:35:07 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] clk: ti: Drop use of clk-private.h
In-Reply-To: <1421970020-11125-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1501231034430.5450@utopia.booyaka.com>
References: <1421970020-11125-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Stephen Boyd wrote:

> These modules don't need to include clk-private.h. Replace the
> include with clk.h because these modules are clock consumers and
> also include clk-provider.h in clk/ti.h because struct
> clk_hw_omap has a struct clk_hw embedded in it.
> 
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Reviewed-by: Paul Walmsley <paul@pwsan.com>


- Paul
