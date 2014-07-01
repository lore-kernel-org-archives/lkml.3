Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbaGAH7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:59:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44946 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaGAH7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:59:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+VVI3vG7raxhi2iaY3OLkD
Date: Tue, 1 Jul 2014 00:59:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, linux@arm.linux.org.uk,
        rnayak@ti.com, santosh.shilimkar@ti.com, joe@perches.com,
        tglx@linutronix.de
Subject: Re: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
Message-ID: <20140701075930.GN28884@atomide.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
 <20140630192910.GA23978@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630192910.GA23978@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Cooper <jason@lakedaemon.net> [140630 12:30]:
> 
> Whole series applied to irqchip/crossbar, I'll give it a day or two in
> -next, then I'll merge it into irqchip/core.
> 
> Tony: Right now, it's immutable unless you tell me I applied something
> incorrectly.  Once it goes into irqchip/core, it's immutable no matter
> what you say. ;-)

Thanks, looks good to me. Sricharan and Nishant, can you please
check that we can now apply the related .dts changes on top of
Jason's branch at:

git://git.infradead.org/users/jcooper/linux.git irqchip/crossbar

Regards,

Tony
