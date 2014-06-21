Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbaFUCJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:09:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25779 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755059AbaFUCJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:09:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182pWK+hQUmfYsc/kLiPNv70dzFJLga6CA=
X-DKIM: OpenDKIM Filter v2.0.1 titan DCD3C59505E
Date: Fri, 20 Jun 2014 22:09:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH] irqchip: brcmstb-l2: Level-2 interrupts are edge
 sensitive
Message-ID: <20140621020939.GB21711@titan.lakedaemon.net>
References: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:05:02AM -0700, Florian Fainelli wrote:
> The driver was configuring the interrupt handler for the Level-2
> interrupts to be "level" triggered while they are in fact "edge"
> triggered. Fix this by using the correct handler.
> 
> Reported-by: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/irqchip/irq-brcmstb-l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to irqchip/urgent

thx,

Jason.
