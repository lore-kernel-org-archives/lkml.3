Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3FRIqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:46:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:24535 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab3FRIqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:46:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="318695983"
Date: Tue, 18 Jun 2013 10:45:54 +0200
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
Subject: Re: [PATCH 4/7] mfd: stmpe: use irq_get_trigger_type() to get IRQ
 flags
Message-ID: <20130618084554.GB7161@zurbaran>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
 <1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 06:40:46PM +0200, Javier Martinez Canillas wrote:
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
