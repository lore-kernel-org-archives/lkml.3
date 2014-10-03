Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaJCNue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:50:34 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14111 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaJCNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:50:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ehgT0Bs8dEB9ZT5ww4rYO3cpDFsCg7Mo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7AF3D5F4C4D
Date: Fri, 3 Oct 2014 09:50:17 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Grzegorz Jaszczyk <jaz@semihalf.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de, ezequiel.garcia@free-electrons.com,
        gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com
Subject: Re: [PATCH 0/2] Marvell Armada 375/38x MPIC/MSI fixes
Message-ID: <20141003135017.GH3895@titan.lakedaemon.net>
References: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 01:17:17PM +0200, Grzegorz Jaszczyk wrote:
> This patchset contains a set of fixes for issues found while doing some test
> with different interrupts configuration on Armada 375 and Armada 38x Marvell
> SoCs. The patches were tested and apply on v3.17-rc6.
> 
> Any feedback is welcome.
> 
> Grzegorz Jaszczyk (2):
>   irqchip: armada-370-xp: fix MSI interrupt handling
>   irqchip: armada-370-xp: fix MPIC interrupt handling
> 
>  drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)

Ah crap.  This slipped off my plate.  Sorry about that.  I've now
applied these to irqchip/urgent with Ezequiel's Ack.  I'll get them into
-next and hopefully do a PR toward the end of next week.

thx,

Jason.
