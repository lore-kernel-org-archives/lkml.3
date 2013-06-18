Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3FRIrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:47:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:3470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab3FRIrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="355365494"
Date: Tue, 18 Jun 2013 10:46:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 3/7] mfd: twl4030-irq: use irq_get_trigger_type() to get
 IRQ flags
Message-ID: <20130618084625.GC7161@zurbaran>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
 <1371228049-27080-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371228049-27080-4-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 06:40:45PM +0200, Javier Martinez Canillas wrote:
> Use irq_get_trigger_type() to get the IRQ trigger type flags
> instead calling irqd_get_trigger_type(irq_get_irq_data(irq))
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
