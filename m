Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaFZHoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:44:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61356 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755321AbaFZHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:44:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Fl5kOyLtEVSmigzIApcjI
Date: Thu, 26 Jun 2014 00:44:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, jason@lakedaemon.net,
        joe@perches.com, Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH V4 2/2] arm: dts: dra7: add crossbar device binding
Message-ID: <20140626074417.GF28884@atomide.com>
References: <1403767532-19290-1-git-send-email-r.sricharan@ti.com>
 <1403767532-19290-3-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403767532-19290-3-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sricharan R <r.sricharan@ti.com> [140626 00:29]:
> From: R Sricharan <r.sricharan@ti.com>
> 
> There is a IRQ crossbar device in the soc, which
> maps the irq requests from the peripherals to the
> mpu interrupt controller's inputs. The Peripheral irq
> requests are connected to only one crossbar
> input and the output of the crossbar is connected to only one
> controller's input line. The crossbar device is used to map
> a peripheral input to a free mpu's interrupt controller line.
> 
> Here, adding a new crossbar device node and replacing all the peripheral
> interrupt numbers with its fixed crossbar input lines.

I think these two patches need to be a single patch to avoid
breaking booting for git bisect inbetween these patches?

Regards,

Tony
