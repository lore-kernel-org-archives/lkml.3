Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3JCSTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:19:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47650 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754264Ab3JCSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:19:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18tCBTgJ31oF2uz7Ngy6jNv
Date: Thu, 3 Oct 2013 11:19:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
Message-ID: <20131003181909.GT8949@atomide.com>
References: <1378230767-54931-1-git-send-email-s-anna@ti.com>
 <20131003180546.GP8949@atomide.com>
 <524DB48B.7020906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524DB48B.7020906@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suman Anna <s-anna@ti.com> [131003 11:25]:
> Tony,
> 
> On 10/03/2013 01:05 PM, Tony Lindgren wrote:
> > * Suman Anna <s-anna@ti.com> [130903 11:00]:
> >> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> >> which are all device-tree boot only. This patch adds the
> >> base support for parsing the DT nodes, and removes the code
> >> dealing with the traditional platform device instantiation.
> > 
> > Great, this should be safe for Ohad to queue:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > 
> 
> There is a v2 of this series [1] that adds additional SoC support as
> well. It currently has some comments [2] & [3] from Mark Rutland on the
> DT bindings. I am looking into that at the moment and it may change this
> patch as well (the DT parse portion of it in
> drivers/hwspinlock/omap_hwspinlock).

OK, yeah I noticed there's some pending comments. Feel free to keep my
ack for the arch/arm/mach-omap2 removal parts, those won't likely
change.

Regards,

Tony
 
> [1] http://marc.info/?l=linux-omap&m=137944644112727&w=2
> [2] http://marc.info/?t=137944636400005&r=1&w=2
> [3] http://marc.info/?t=137944636400004&r=1&w=2
> 
> 
