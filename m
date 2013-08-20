Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3HTVyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:54:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42181 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3HTVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:54:36 -0400
Date: Tue, 20 Aug 2013 22:51:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, robherring2@gmail.com, grant.likely@linaro.org,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 3/4] clk: Provide not locked variant of
	of_clk_get_from_provider()
Message-ID: <20130820215121.GG17845@n2100.arm.linux.org.uk>
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com> <1377020063-30213-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377020063-30213-4-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 07:34:22PM +0200, Sylwester Nawrocki wrote:
> Add helper functions for the of_clk_providers list locking and
> an unlocked variant of of_clk_get_from_provider().
> These functions are intended to be used in the clkdev to avoid
> race condition in the device tree based clock look up in clk_get().
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v1:
>  - moved the function declaractions to a local header.

Yes, this is a much better solution, thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
