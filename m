Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaLLXYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:24:25 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59806 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaLLXYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:24:22 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20141212230543.GX11285@n2100.arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1418425456-19364-1-git-send-email-sboyd@codeaurora.org>
 <20141212230543.GX11285@n2100.arm.linux.org.uk>
Message-ID: <20141212232416.20398.58297@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: Really fix deadlock with mmap_sem
Date: Fri, 12 Dec 2014 15:24:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Russell King - ARM Linux (2014-12-12 15:05:43)
> On Fri, Dec 12, 2014 at 03:04:16PM -0800, Stephen Boyd wrote:
> > Commit 6314b6796e3c (clk: Don't hold prepare_lock across debugfs
> > creation, 2014-09-04) forgot to update one place where we hold
> > the prepare_lock while creating debugfs directories. This means
> > we still have the chance of a deadlock that the commit was trying
> > to fix. Actually fix it by moving the debugfs creation outside
> > the prepare_lock.
> > 
> > Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
> 
> Please use "Russell King <rmk+kernel@arm.linux.org.uk>" rather than this
> address, thanks.

Applied to clk-next and fixed up the email address locally.

Regards,
Mike

> 
> -- 
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
