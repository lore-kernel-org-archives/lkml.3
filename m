Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbbALUgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:36:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53539 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbALUgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:36:02 -0500
Date: Mon, 12 Jan 2015 15:35:59 -0500 (EST)
Message-Id: <20150112.153559.783855617585288378.davem@davemloft.net>
To: alexandre.belloni@free-electrons.com
Cc: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/at91_ether: prepare and unprepare clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420671566-30784-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1420671566-30784-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 12:36:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Date: Wed,  7 Jan 2015 23:59:26 +0100

> The clock is enabled without being prepared, this leads to:
> 
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:889 __clk_enable+0x24/0xa8()
> 
> and a non working ethernet interface.
> 
> Use clk_prepare_enable() and clk_disable_unprepare() to handle the clock.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks.
