Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966913AbaFTStK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:49:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21623 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966308AbaFTStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:49:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19RJWVe5W7hukSIHZ94uKJyZQIHhGnQAvs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 53E955944D1
Date: Fri, 20 Jun 2014 14:48:57 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irqchip: brcmstb-l2: Level-2 interrupts are edge
 sensitive
Message-ID: <20140620184857.GB21711@titan.lakedaemon.net>
References: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com>
 <CAGVrzcZmakEpNW=vGtsb+OmzU_J4hJNoM1sUAoYNsaju_YzGwQ@mail.gmail.com>
 <CAGVrzcbpS0tJtkH5vkGRSteV5NU2CzNNkQ43_26XySFqJMAK5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcbpS0tJtkH5vkGRSteV5NU2CzNNkQ43_26XySFqJMAK5A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:26:33AM -0700, Florian Fainelli wrote:
> 2014-06-12 12:13 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> > 2014-06-09 11:05 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> >> The driver was configuring the interrupt handler for the Level-2
> >> interrupts to be "level" triggered while they are in fact "edge"
> >> triggered. Fix this by using the correct handler.
> >>
> >> Reported-by: Brian Norris <computersforpeace@gmail.com>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Jason, Thomas, this driver just got merged into 3.16-rc0, can you
> > carry this fix such that it gets into a future 3.16-rc? Thanks!
> 
> Ping! I want to make sure this gets into a next 3.16-rc pull request.
> Andrew, can you take that one if neither Thomas nor Andrew respond in
> a timely manner?
> 
> Thanks!

relax.  ;-)  I'm doing at least fixes today.

thx,

Jason.
