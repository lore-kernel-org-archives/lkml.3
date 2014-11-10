Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKJWei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:34:38 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22678 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbaKJWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:34:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3YDm7VvWtz0Hxi6a1tO+M
Date: Mon, 10 Nov 2014 14:33:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: bcousson@baylibre.com, nm@ti.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: dts: dra72x-evm: Enable CPSW and MDIO
Message-ID: <20141110223351.GZ31454@atomide.com>
References: <1415008693-28552-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415008693-28552-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mugunthan V N <mugunthanvnm@ti.com> [141103 01:59]:
> Adding CPSW phy-id, CPSW and MDIO pinmux configuration for active and
> sleep states and enable them in board evm dts file.
> 
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
> 
> Adding device tree entry for CPSW to make it work in Switch mode.
> Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pushed
> my tree to [2].
> 
> Did a boot test with CPSW and ping test with suspend/resume, the boot logs
> on DRA72x EVM are posted at [3]
> 
> This patch depends on the DRA7xx CPSW support patch series [4] and one driver
> patch (47276fc drivers: net:cpsw: fix probe_dt when only slave 1 is pinned out)
> which is already present in linux-next

Applying into omap-for-v3.19/dt thanks.

Tony
 
> [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
> [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git for-v3.19/dra72-evm-cpsw
> [3] http://pastebin.ubuntu.com/8800549/
> [4] http://comments.gmane.org/gmane.linux.kernel/1810171
