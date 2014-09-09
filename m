Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaIIJYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:24:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55228 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932089AbaIIJYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:24:16 -0400
Date: Tue, 9 Sep 2014 11:24:11 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] irqchip: atmel-aic: add RTT irq fixup
Message-ID: <20140909092411.GH14623@piout.net>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 at 11:07:46 +0200, Boris Brezillon wrote :
> Hello,
> 
> This patch series add a new fixup function for the RTT (Real Time Timer)
> block and make use of it on SoCs integrating at least one RTT to prevent
> spurious interrupts on the first interrupt line.
> 
> This fixup function was previously implemented in
> arch/arm/mach-at91/sysirq_mask.c, but is now moved to the AIC driver so
> that we can remove SoC specific hooks in arch/arm/mach-at91/ when booting
> a DT kernel.
> 
> This series also reworks the naming convention of the SoC specific fixup
> functions and add an entry for the at91rm9200.
> 
> The series depends on the acceptation of the RTT DT bindings proposed here
> [1].
> 

Whole series is:

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
