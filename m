Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaFZHmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:42:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57885 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755342AbaFZHmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:42:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+JRfLN3lAEwTuv0raLIzOb
Date: Thu, 26 Jun 2014 00:42:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, jason@lakedaemon.net,
        joe@perches.com
Subject: Re: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
Message-ID: <20140626074209.GE28884@atomide.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sricharan R <r.sricharan@ti.com> [140626 00:14]:
> This series does some cleanups, fixes for handling two interrupts
> getting mapped twice to same crossbar and provides support for
> hardwired IRQ and crossbar definitions.
> 
> On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10,
> 131, 132, 133 are direct wired to hardware blocks bypassing
> crossbar. This quirky implementation is *NOT* supposed to be the
> expectation of crossbar hardware usage. This series adds support
> to represent such hard-wired irqs through DT and avoid generic
> allocation/programming of crossbar in the driver.
> 
> This way of supporting hard-wired irqs was a result of
> the below discussions.
> http://www.spinics.net/lists/arm-kernel/msg329946.html
> 
> Based on 3.16 rc2 mainline.

Jason, once these patches look OK for merging, can you please
set them up into an immutable branch so I too can merge them in?

The immutable branch is needed so I can eventually apply
the related .dts changes to enable the crossbar interrupts.

Regards,

Tony
