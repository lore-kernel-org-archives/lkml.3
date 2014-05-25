Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbaEYRMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 13:12:30 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12402 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaEYRM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 13:12:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Itepei1g2neS2ot+5kSsGVEq3KTyKewI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4162157F8F7
Date: Sun, 25 May 2014 13:12:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] irqchip: Broadcom Set Top Box Level-2 interrupt
 controller
Message-ID: <20140525171211.GK8664@titan.lakedaemon.net>
References: <1400892054-24457-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400892054-24457-1-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 05:40:52PM -0700, Florian Fainelli wrote:
> Hi Thomas, Jason,
> 
> This patch set adds an irqchip driver for the Broadcom Set Top Box Level-2
> interrupt controller hardware, as well as a corresponding Device Tree binding
> document.
> 
> Thanks!
> 
> Florian Fainelli (2):
>   irqchip: add Broadcom Set Top Box Level-2 interrupt controller
>   Documentation: add Broadcom STB Level-2 interrupt controller binding
> 
>  .../bindings/interrupt-controller/brcm,l2-intc.txt |  29 +++
>  drivers/irqchip/Kconfig                            |   6 +
>  drivers/irqchip/Makefile                           |   1 +
>  drivers/irqchip/irq-brcmstb-l2.c                   | 231 +++++++++++++++++++++
>  4 files changed, 267 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
>  create mode 100644 drivers/irqchip/irq-brcmstb-l2.c

Applied to irqchip/core

thx,

Jason.
