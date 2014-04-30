Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbaD3TTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:19:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43902 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbaD3TTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:19:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Dinh Nguyen <dinguyen@altera.com>, "ZY - pavel" <pavel@denx.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1398379669.14881.2.camel@linux-builds1>
Cc: dinh.linux@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1397481336-5592-1-git-send-email-dinguyen@altera.com>
 <20140424152133.GA23032@amd.pavel.ucw.cz>
 <1398379669.14881.2.camel@linux-builds1>
Message-ID: <20140430191902.5718.91761@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: socfpga: fix clock driver for 3.15
Date: Wed, 30 Apr 2014 12:19:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dinh Nguyen (2014-04-24 15:47:49)
> Hi Mike,
> 
> On Thu, 2014-04-24 at 17:21 +0200, ZY - pavel wrote:
> > Hi!
> > 
> > > commit [1771b10d6 clk: respect the clock dependencies in of_clk_init]
> > > exposed a flaw in the socfpga clock driver and prevents the platform
> > > from booting on 3.15-rc1.
> > > 
> > > Because the "altr,clk-mgr" is not really a clock, it should not be using
> > > CLK_OF_DECLARE, instead we should be mapping the clk-mgr's base address
> > > one of the functional clock init function. Use the socfpga_pll_init function
> > > to map the clk_mgr_base_addr as this clock should always be initialized first.
> > > 
> > > Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
> > 
> > Works for me, thanks!
> >                                                                       Pavel
> > 
> > Tested-by: Pavel Machek <pavel@denx.de>
> > 
> 
> I'm hoping you can queued this up for one of the 3.15-rc.

I took this in a few days ago but forgot to reply. It's in clk-fixes for
the next batch.

Regards,
Mike

> 
> Thanks,
> Dinh
> 
> 
