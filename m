Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaJJFU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:20:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45974 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJJFU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:20:26 -0400
Date: Fri, 10 Oct 2014 01:20:23 -0400 (EDT)
Message-Id: <20141010.012023.36814195496313730.davem@davemloft.net>
To: bobby.prani@gmail.com
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        matthew.vick@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] networking: fm10k: Fix build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412918346-24763-1-git-send-email-bobby.prani@gmail.com>
References: <1412918346-24763-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Oct 2014 22:20:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 10 Oct 2014 01:19:06 -0400

> The latest linus git tip (3.18-rc1) fails with the following build failure. Fix
> this by making PTP support explicit for fm10k driver.
> 
> rivers/built-in.o: In function `fm10k_ptp_register':
> (.text+0x12e760): undefined reference to `ptp_clock_registER'
> drivers/built-in.o: In function `fm10k_ptp_unregister':
> (.text+0x12e7dc): undefined reference to `ptp_clock_unregister'
> Makefile:930: recipe for target 'vmlinux' failed
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Applied, thanks.
