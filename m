Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaINGW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 02:22:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48438 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752302AbaINGW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 02:22:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18esR0Luaezkop383sIus8EDQuQ1lKKa0A=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0EB755E1423
Date: Sun, 14 Sep 2014 02:22:52 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        computersforpeace@gmail.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/2] irqchip: Broadcom BCM7120-style Level 2
 interrupt controller
Message-ID: <20140914062252.GL21986@titan.lakedaemon.net>
References: <1410309862-27784-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410309862-27784-1-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:44:20PM -0700, Florian Fainelli wrote:
> Hi Jason, Thomas, Mark,
> 
> This patch set adds support for the second type of Level-2 interrupt controller
> found on Broadcom Set Top Box hardware.
> 
> Version 2 should address your previous comments made on the initial submission.
> 
> Thanks!
> 
> Florian Fainelli (2):
>   irqchip: add Broadcom BCM7120-style Level 2 interrupt controller
>   Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding
> 
>  .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  86 ++++++++
>  drivers/irqchip/Makefile                           |   3 +-
>  drivers/irqchip/irq-bcm7120-l2.c                   | 220 +++++++++++++++++++++
>  3 files changed, 308 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
>  create mode 100644 drivers/irqchip/irq-bcm7120-l2.c

Fixed up one unused variable warning and applied to irqchip/broadcom

thx,

Jason.
