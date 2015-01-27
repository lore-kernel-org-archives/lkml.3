Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbbA0UAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:00:39 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42271 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672AbbA0UAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:00:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Paul Walmsley <paul@pwsan.com>, "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <alpine.DEB.2.02.1501231034430.5450@utopia.booyaka.com>
Cc: linux-kernel@vger.kernel.org, "Tero Kristo" <t-kristo@ti.com>,
        "Tony Lindgren" <tony@atomide.com>
References: <1421970020-11125-1-git-send-email-sboyd@codeaurora.org>
 <alpine.DEB.2.02.1501231034430.5450@utopia.booyaka.com>
Message-ID: <20150127200023.22722.41056@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: ti: Drop use of clk-private.h
Date: Tue, 27 Jan 2015 12:00:23 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Walmsley (2015-01-23 02:35:07)
> On Thu, 22 Jan 2015, Stephen Boyd wrote:
> 
> > These modules don't need to include clk-private.h. Replace the
> > include with clk.h because these modules are clock consumers and
> > also include clk-provider.h in clk/ti.h because struct
> > clk_hw_omap has a struct clk_hw embedded in it.
> > 
> > Cc: Tero Kristo <t-kristo@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Paul Walmsley <paul@pwsan.com>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Reviewed-by: Paul Walmsley <paul@pwsan.com>

Applied to clk-next.

Regards,
Mike

> 
> 
> - Paul
