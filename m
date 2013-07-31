Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab3GaHiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:38:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28482 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab3GaHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:38:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+rnCnpB4579PxgTYfbOqRi
Date: Wed, 31 Jul 2013 00:38:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: ksummit-2013-discuss@lists.linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [ATTEND] [ARM ATTEND] kernel data bloat and how to avoid it
Message-ID: <20130731073802.GT7656@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Probably the biggest kernel data bloat issue is in the ARM land, but
it also seems that it's becoming a Linux generic issue too, so I
guess it could be discussed in either context.

The kernel data bloat issue is slightly related to the devicetree talks
as well as I'm seeing a lot of the device tree bindings heading the wrong
way both at the binding level and the device driver level.

Basically the data bloat issue is there for the arch code and drivers
and may not show up initially until things have headed the wrong way for
too long.

After struggling with the data issues in the ARM land over past few
years, I think we have now pretty good idea how to spot the issues
early and avoid building databases into Linux kernel.

So some kind of discussion on data bloat and how to avoid it might be
interesting to a bunch of maintainers?

Regards,

Tony
