Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbaDXPWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:22:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55219 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbaDXPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:21:35 -0400
Date: Thu, 24 Apr 2014 17:21:33 +0200
From: Pavel Machek <pavel@denx.de>
To: dinguyen@altera.com
Cc: dinh.linux@gmail.com, mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: socfpga: fix clock driver for 3.15
Message-ID: <20140424152133.GA23032@amd.pavel.ucw.cz>
References: <1397481336-5592-1-git-send-email-dinguyen@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397481336-5592-1-git-send-email-dinguyen@altera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> commit [1771b10d6 clk: respect the clock dependencies in of_clk_init]
> exposed a flaw in the socfpga clock driver and prevents the platform
> from booting on 3.15-rc1.
> 
> Because the "altr,clk-mgr" is not really a clock, it should not be using
> CLK_OF_DECLARE, instead we should be mapping the clk-mgr's base address
> one of the functional clock init function. Use the socfpga_pll_init function
> to map the clk_mgr_base_addr as this clock should always be initialized first.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@altera.com>

Works for me, thanks!
									Pavel

Tested-by: Pavel Machek <pavel@denx.de>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
