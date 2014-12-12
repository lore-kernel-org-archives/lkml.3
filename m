Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaLLXFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:05:51 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:54681 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753314AbaLLXFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:05:50 -0500
Date: Fri, 12 Dec 2014 23:05:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Really fix deadlock with mmap_sem
Message-ID: <20141212230543.GX11285@n2100.arm.linux.org.uk>
References: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 03:04:16PM -0800, Stephen Boyd wrote:
> Commit 6314b6796e3c (clk: Don't hold prepare_lock across debugfs
> creation, 2014-09-04) forgot to update one place where we hold
> the prepare_lock while creating debugfs directories. This means
> we still have the chance of a deadlock that the commit was trying
> to fix. Actually fix it by moving the debugfs creation outside
> the prepare_lock.
> 
> Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>

Please use "Russell King <rmk+kernel@arm.linux.org.uk>" rather than this
address, thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
