Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3IRRp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:45:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24025 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807Ab3IRRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:45:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+4TrnD8FsubCjXsH/kXMT
Date: Wed, 18 Sep 2013 10:45:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130918174520.GV9994@atomide.com>
References: <201302171616.50152@pali>
 <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
 <201303062112.06417@pali>
 <201309062234.05878@pali>
 <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
 <20130917235028.GR9994@atomide.com>
 <CAAwP0s3MBd58Q9wijQP9Nd_DB4GdicE-b427cHS-UXYS4HW-Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAwP0s3MBd58Q9wijQP9Nd_DB4GdicE-b427cHS-UXYS4HW-Jg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Javier Martinez Canillas <martinez.javier@gmail.com> [130918 07:20]:
> 
> Hi Tony,
> 
> I don't know if OMAP2+ DT will happen soon as you said. At least I
> know about a big issue we had with GPIO pins not being auto-requested
> when are mapped as IRQ. You can refer to [1] for the latest approach
> and how this discussion have been going.
> 
> This is something that we have been trying to solve for a couple of
> kernel releases by now so it would be great if you can join the
> discussion.

Yes I'm painfully aware of that mess too, that needs to be
sorted out for sure.

Regards,

Tony
 
> [1]: https://lkml.org/lkml/2013/8/26/260
