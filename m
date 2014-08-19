Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaHSPL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:11:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41466 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbaHSPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:11:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/jpyZkgsXAcHiAk2Is0mBgq52LL7AlOQE=
X-DKIM: OpenDKIM Filter v2.0.1 titan EED7D5C9B66
Date: Tue, 19 Aug 2014 11:11:22 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Feng Kan <fkan@apm.com>
Cc: tglx@linutronix.de, marc.zyngier@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 RESEND 0/2] irqchip: gic: Add support for GIC v2
 bypass disable
Message-ID: <20140819151122.GT12769@titan.lakedaemon.net>
References: <1406757419-18729-1-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406757419-18729-1-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng,

On Wed, Jul 30, 2014 at 02:56:57PM -0700, Feng Kan wrote:
> This patch series cleans up hex number in the gic driver and then adds
> the code to preserve GIC v2 bypass disable bits in the GIC driver.
> 
> V4 Change: rebase off latest irq tree, merge after gic v3 changes.
> 
> V3 Change: remove incorrect Signoff by 
> 
> V2 Change:
> 	seem my send email was not working correctly, resending this with
>         rebase pull.
> 	- had to pull HaoJian's change out of arm-gic.h to keep consistency.
> 	- replace GIC defines as noted by Marc
> 	- remove GIC_CPU_DISABLE since it no longer used.
> 	- fix gic_cpu_if_down as noted by Marc
> 
> 
> Feng Kan (2):
>   irqchip: gic: replace hex numbers with defines.
>   irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register
> 
>  drivers/irqchip/irq-gic-common.c | 15 +++++++------
>  drivers/irqchip/irq-gic.c        | 46 ++++++++++++++++++++++++++++------------
>  include/linux/irqchip/arm-gic.h  | 16 ++++++++++++++
>  3 files changed, 58 insertions(+), 19 deletions(-)

I've tentatively applied this to irqchip/gic and will merge it into
irqchip/core within the next week or so.

thx,

Jason.
