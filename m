Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3J3AUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:20:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41921 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3J3AUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:20:12 -0400
Date: Wed, 30 Oct 2013 00:19:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, kyungmin.park@samsung.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v7 4/5] clk: Add common __clk_get(), __clk_put()
	implementations
Message-ID: <20131030001924.GX16735@n2100.arm.linux.org.uk>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com> <1383076268-8984-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383076268-8984-5-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:51:07PM +0100, Sylwester Nawrocki wrote:
> This patch adds common __clk_get(), __clk_put() clkdev helpers that
> replace their platform specific counterparts when the common clock
> API is used.
> 
> The owner module pointer field is added to struct clk so a reference
> to the clock supplier module can be taken by the clock consumers.
> 
> The owner module is assigned while the clock is being registered,
> in functions _clk_register() and __clk_register().
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
