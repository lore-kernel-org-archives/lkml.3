Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaEUUCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:02:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62525 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaEUUCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:02:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JKLED3LmijFhTWg/NdRhcglDBf+moEB8=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6234457C7D4
Date: Wed, 21 May 2014 16:01:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux@openrisc.net, jonas@southpole.se
Subject: Re: [PATCH v2] openrisc: irq: use irqchip framework
Message-ID: <20140521200156.GJ8664@titan.lakedaemon.net>
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
 <20140521195056.GA14701@chokladfabriken.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521195056.GA14701@chokladfabriken.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:50:57PM +0300, Stefan Kristiansson wrote:
...
> I see two paths to go to get there though, and here's where I'd like some input.
> 1) Define the three different implementations as seperate irqchips,
>    with accompanying IRQCHIP_DECLARE.
> 2) Add custom device-tree bindings and determine the chip type from that.
> 
> What would be the best choice here?
> I think I'm leaning towards 1) and I have a tentative patch for that,
> but I wanted to went the question before posting it.

Are there actually three IP blocks here that we may see separately
somewhere else?

thx,

Jason.
