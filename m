Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaIZTte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:49:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50498 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaIZTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:49:32 -0400
Date: Fri, 26 Sep 2014 15:49:30 -0400 (EDT)
Message-Id: <20140926.154930.1459165439870528648.davem@davemloft.net>
To: soren.brinkmann@xilinx.com
Cc: nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Revert "net/macb: add pinctrl consumer support"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411429748-31444-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1411429748-31444-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Sep 2014 12:49:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Date: Mon, 22 Sep 2014 16:49:08 -0700

> This reverts commit 8ef29f8aae524bd51298fb10ac6a5ce6c4c5a3d8.
> The driver core already calls pinctrl_get() and claims the default
> state. There is no need to replicate this in the driver.
> ---
> Hi,
> 
> I might be mistaken, but I think the driver core does already take care of
> calling into the pinctrl framework and the driver does not need to do it on its
> own (drivers/base/dd.c:really_probe() calls 'pinctrl_bind_pins() which takes
> care of the pinctrl setup).
> 

Applied and queued up for -stable, thanks.

Next time please provide a proper "Signed-off-by: " in the commit message
of your submission.
