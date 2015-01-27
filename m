Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbbA0B0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:26:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46592 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbA0B0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:26:31 -0500
Date: Mon, 26 Jan 2015 17:26:30 -0800 (PST)
Message-Id: <20150126.172630.1182911088830479483.davem@davemloft.net>
To: michal.simek@xilinx.com
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, nicolas.ferre@atmel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: macb: Remove CONFIG_PM ifdef because of
 compilation warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <7970145ad4d864eaf31d694d22f2fecbcf6825c9.1422002161.git.michal.simek@xilinx.com>
References: <7970145ad4d864eaf31d694d22f2fecbcf6825c9.1422002161.git.michal.simek@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Jan 2015 17:26:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>
Date: Fri, 23 Jan 2015 09:36:03 +0100

> Fix compilation warning:
> drivers/net/ethernet/cadence/macb.c:2415:12: warning: 'macb_suspend'
> defined but not used [-Wunused-function]
>  static int macb_suspend(struct device *dev)
> drivers/net/ethernet/cadence/macb.c:2432:12: warning: 'macb_resume'
> defined but not used [-Wunused-function]
>  static int macb_resume(struct device *dev)
> 
> when CONFIG_PM=y, CONFIG_PM_SLEEP=n are used.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Applied.
