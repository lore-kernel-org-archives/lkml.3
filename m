Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaHOIsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:48:22 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50864 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751319AbaHOIsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:48:21 -0400
Date: Fri, 15 Aug 2014 09:48:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Neil Zhang <zhangwm@marvell.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: irq: fix the affinity when migrate a irq
Message-ID: <20140815084812.GU30401@n2100.arm.linux.org.uk>
References: <1408087917-22603-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408087917-22603-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 03:31:57PM +0800, Neil Zhang wrote:
> Commit ffde1de64012 ("irqchip: Gic: Support forced affinity setting")
> has enable the forcing cpu affinity of interrupts for gic.
> 
> The current code of migrate_one_irq will pass the current affinity mask
> to irq_set_affinity with force is true, it may select the cpu being
> offlined as the target CPU again, then the interrupt won't be migrated
> correctly.

NAK.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
