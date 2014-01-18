Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaARDKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:10:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaARDKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:10:53 -0500
Date: Fri, 17 Jan 2014 19:10:53 -0800 (PST)
Message-Id: <20140117.191053.2165670259882490823.davem@davemloft.net>
To: swarren@wwwdotorg.org
Cc: dbaryshkov@gmail.com, marcel@holtmann.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net,
        alex.bluesman.smirnov@gmail.com, netdev@vger.kernel.org,
        jukka.rissanen@linux.intel.com, swarren@nvidia.com
Subject: Re: [PATCH] Bluetooth: remove direct compilation of 6lowpan_iphc.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389986964-5177-1-git-send-email-swarren@wwwdotorg.org>
References: <1389986964-5177-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>
Date: Fri, 17 Jan 2014 12:29:24 -0700

> From: Stephen Warren <swarren@nvidia.com>
> 
> It's now built as a separate utility module, and enabling BT selects
> that module in Kconfig. This fixes:
 ...
> (this change probably simply wasn't "git add"d to a53d34c3465b)
> 
> Fixes: a53d34c3465b ("net: move 6lowpan compression code to separate module")
> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied to net-next, thanks a lot.
