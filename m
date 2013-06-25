Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3FYN6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:58:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:56022 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3FYN6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:58:49 -0400
Date: Tue, 25 Jun 2013 15:58:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
In-Reply-To: <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
Message-ID: <alpine.DEB.2.02.1306251551020.4013@ionos.tec.linutronix.de>
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Christian Ruppert wrote:
> The SOC interrupt controller driver for the Abilis Systems TB10x series of
> SOCs based on ARC700 CPUs.
> 
> This patch depends on commits eb76bdd407d8a90e59a06cb0158886df390e5d1c and
> 712bc93df9e7f14b8a163148d2aa7c778e151627 from branch irq/for-arm of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git.

This should go below --- as it is not part of the changelog.
 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Why is Pierrick in the SOB chain? 

> ---
>  .../interrupt-controller/abilis,tb10x-ictl.txt     |   38 ++++
>  arch/arc/boot/dts/abilis_tb100.dtsi                |   32 ++--
>  arch/arc/boot/dts/abilis_tb101.dtsi                |   32 ++--
>  arch/arc/boot/dts/abilis_tb10x.dtsi                |   32 ++--
>  arch/arc/plat-tb10x/Kconfig                        |    1 +
>  drivers/irqchip/Kconfig                            |    5 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-tb10x.c                        |  195 ++++++++++++++++++++

I can pick it up, but I'm not so fond of carrying arch/arc patches
which might conflict with other stuff in the arc tree. Veenet, if I
should pick the whole thing up, I'd like to have an acked-by at least.

Thanks,

	tglx

