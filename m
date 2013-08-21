Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3HUNJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:09:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:36223 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3HUNJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:09:43 -0400
Date: Wed, 21 Aug 2013 15:09:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] irq-imgpdc: add ImgTec PDC irqchip driver
In-Reply-To: <1375101860-6657-1-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.DEB.2.02.1308211508580.4089@ionos.tec.linutronix.de>
References: <1375101860-6657-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013, James Hogan wrote:

> Add irqchip driver for the ImgTec PowerDown Controller (PDC) as found in
> the TZ1090. The PDC has a number of general system wakeup (SysWake)
> interrupts (which would for example be connected to a power button or an
> external peripheral), and a number of peripheral interrupts which can
> also wake the system but are connected straight to specific low-power
> peripherals (such as RTC or Infrared). It has a single interrupt output
> for SysWakes, and individual interrupt outputs for each peripheral.
> 
> The driver demuxes the SysWake interrupt line, and passes the peripheral
> interrupts straight through. It also handles the set_wake interrupt
> operation to enable/disable the appropriate wake event bits.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: linux-metag@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
> Thomas: I'd appreciate your ack if this driver looks okay to you now,
> then I'm happy to take it through the metag arch tree for v3.12
> (although you're welcome to take it through tip if you prefer).

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Please take it through your tree. It has no dependencies on my stuff.
 
