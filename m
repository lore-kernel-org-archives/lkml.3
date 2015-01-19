Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbbASQgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:36:16 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46498 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbASQgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:36:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tony Lindgren <tony@atomide.com>, "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20150114220649.22722.26307@quantum>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <1421189488-9657-1-git-send-email-tony@atomide.com>
 <20150114220649.22722.26307@quantum>
Message-ID: <20150119163601.22722.19233@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 0/2] Minimal FAPLL clock support for dm816x
Date: Mon, 19 Jan 2015 08:36:01 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mike Turquette (2015-01-14 14:06:49)
> Quoting Tony Lindgren (2015-01-13 14:51:26)
> > Hi all,
> > 
> > Here's a minimal support for the FAPLL (Flying Adder PLL) on dm816x
> > which is a omap variant.
> 
> Tony,
> 
> Patches look fine to me. I'll give it a few days for Paul or Tero to
> comment if they have any concerns.

Applied to clk-next.

Regards,
Mike

> 
> Also, "flying adder pll" is a pretty badass pll name.
> 
> Regards,
> Mike
> 
> > 
> > Regards,
> > 
> > Tony
> > 
> > 
> > Tony Lindgren (2):
> >   clk: ti: Add support for FAPLL on dm816x
> >   clk: ti: Initialize clocks for dm816x
> > 
> >  .../devicetree/bindings/clock/ti/fapll.txt         |  33 ++
> >  drivers/clk/ti/Makefile                            |   1 +
> >  drivers/clk/ti/clk-3xxx.c                          |   8 +-
> >  drivers/clk/ti/clk-816x.c                          |  53 +++
> >  drivers/clk/ti/fapll.c                             | 410 +++++++++++++++++++++
> >  5 files changed, 498 insertions(+), 7 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/clock/ti/fapll.txt
> >  create mode 100644 drivers/clk/ti/clk-816x.c
> >  create mode 100644 drivers/clk/ti/fapll.c
> > 
> > -- 
> > 2.1.4
> > 
