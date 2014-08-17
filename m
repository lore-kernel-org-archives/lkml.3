Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaHQTjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 15:39:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29363 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbaHQTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 15:39:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Bjy0W2bvs1Mbn/V1eu2w+r+lumekqEX0=
X-DKIM: OpenDKIM Filter v2.0.1 titan EE4C85C81A0
Date: Sun, 17 Aug 2014 15:39:02 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, santosh.shilimkar@ti.com,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        ivan.khoronzhuk@ti.com, m-karicheri2@ti.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] irqchip: add keystone irq controller ip driver
Message-ID: <20140817193902.GK12769@titan.lakedaemon.net>
References: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:40:30PM +0300, Grygorii Strashko wrote:
> On Keystone SOCs, DSP cores can send interrupts to ARM
> host using the IRQ controller IP. It provides 28 IRQ
> signals to ARM. The IRQ handler running on HOST OS can
> identify DSP signal source by analyzing SRCCx bits in
> IPCARx registers. This is one of the component used by
> the IPC mechanism used on Keystone SOCs.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> Changes in v2:
> - minor comments and fixes applied
> 
> v1:
>  https://lkml.org/lkml/2014/7/14/549
> 
>  .../interrupt-controller/ti,keystone-irq.txt       |   36 +++
>  drivers/irqchip/Kconfig                            |    7 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-keystone.c                     |  232 ++++++++++++++++++++
>  4 files changed, 276 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
>  create mode 100644 drivers/irqchip/irq-keystone.c

I've applied this to the topic branch irqchip/keystone.  I'll let it
cook in -next for a few days (keep in mind Stephen is at KS this week).
Then I'll merge it into irqchip/core and you can use /keystone as a
stable base for other work this cycle.

thx,

Jason.
