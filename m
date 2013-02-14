Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082Ab3BNWxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:53:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548Ab3BNWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:53:08 -0500
Date: Thu, 14 Feb 2013 17:52:59 -0500 (EST)
Message-Id: <20130214.175259.958737100257982860.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, mugunthanvnm@ti.com, hvaibhav@ti.com,
        richardcochran@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 6/9] net: cwdavinci_cpdma: export symbols for cpsw
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360882071-4072668-7-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
	<1360882071-4072668-7-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 14 Feb 2013 23:47:48 +0100

> With the support for ARM AM33xx in multiplatform kernels
> in 3.9, an older bug appears in ARM allmodconfig:
> When the cpsw driver is built as a module with cpdma
> support enabled, it uses symbols that the cpdma driver
> does not export.
> 
> Without this patch, building allmodconfig results in:
> 
> ERROR: "cpdma_ctlr_int_ctrl" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> ERROR: "cpdma_control_set" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> ERROR: "cpdma_ctlr_eoi" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: David S. Miller <davem@davemloft.net>
