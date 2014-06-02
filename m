Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaFBCsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:48:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55591 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaFBCsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:48:03 -0400
Date: Sun, 01 Jun 2014 19:48:02 -0700 (PDT)
Message-Id: <20140601.194802.439655175826998004.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        nm@ti.com, broonie@kernel.org
Subject: Re: [PATCH] net: ks8851: Don't use regulator_get_optional()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401307872-23190-1-git-send-email-sboyd@codeaurora.org>
References: <1401307872-23190-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Jun 2014 19:48:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Wed, 28 May 2014 13:11:12 -0700

> We shouldn't be using regulator_get_optional() here. These
> regulators are always present as part of the physical design and
> there isn't any way to use an internal regulator or change the
> source of the reference voltage via software. Given that the only
> users of this driver in the kernel are DT based, this change
> should be transparent to them even if they don't specify any
> supplies because the regulator framework will insert dummy
> supplies as needed.
> 
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

This patch only applies to net-next, please make that explicit in your
future submissions by saying something like "[PATCH net-next] ..."
in your Subject line.

Applied, thanks.
